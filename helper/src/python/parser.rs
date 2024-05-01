use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct PythonParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for PythonParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }

    /// Increase the line number as long as we're inside the parameter
    /// definition of a multi-line function.
    fn postprocess_line(&self, line: usize) -> usize {
        for node in traverse::PreOrder::new(self.tree.root_node().walk()) {
            if node.start_position().row + 1 == line {
                // Find the body of the function, that's where the insert
                // position should be, but rather finding the actual body, we
                // find the colon after the return type, because there might be
                // a docblock after the colon and before the body and we still
                // want to insert before this.
                //
                // Example:
                //      def foo() -> int:   <-- insert after here
                //          # Comment       <-- considered separate from body
                //          pass            <-- start of the body
                let colon_node = node
                    .children(&mut node.walk())
                    .filter(|node| node.kind() == ":")
                    .next();

                if colon_node.is_some() {
                    return colon_node.unwrap().start_position().row + 1;
                }
            }
        }

        line
    }
}

impl<'a> PythonParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_python::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "class_definition" => Some(self.parse_class(&child_node)),
                    "function_definition" => Some(self.parse_function(&child_node)),
                    _ => None,
                };
            }
        }

        None
    }

    fn parse_class(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "identifier" => {
                    tokens.insert("name".to_string(), Value::String(self.get_node_text(&child_node)));
                },
                "block" => {
                    let attributes = self.parse_class_attributes(&child_node);
                    if !attributes.is_empty()  {
                        tokens.insert("attributes".to_string(), Value::Array(attributes));
                    }
                }
                _ => {},
            }
        }

        Ok(tokens)
    }

    fn parse_class_attributes(&self, node: &Node) -> Vec<Value> {
        let mut attributes = Vec::new();

        node
            .children(&mut node.walk())
            .filter(|node| node.kind() == "expression_statement")
            .for_each(|node| {
                let mut attr = Map::new();

                node
                    .children(&mut node.walk())
                    .filter(|node| node.kind() == "assignment")
                    .for_each(|node|
                        for child_node in node.children(&mut node.walk()) {
                            match child_node.kind() {
                                "identifier" => {
                                    attr.insert("name".to_string(), Value::String(self.get_node_text(&child_node)));
                                },
                                "type" => {
                                    attr.insert("type".to_string(), Value::String(self.get_node_text(&child_node)));
                                },
                                _ => {}
                            }
                        }
                    );

                attributes.push(Value::Object(attr));
            });

        attributes
    }


    fn parse_function(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        let mut is_class_method = false;
        if let Some(parent_node) = node.parent().unwrap().parent() {
            if parent_node.kind() == "class_definition" {
                is_class_method = true;
            }
        }

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "type" => {
                    let value = Value::String(self.get_node_text(&child_node));
                    if value != "None" {
                        tokens.insert("return_type".to_string(), value);
                    }
                },
                "parameters" => {
                    let mut params = Vec::new();

                    child_node
                        .children(&mut child_node.walk())
                        .filter(|node|
                            [
                                "default_parameter",
                                "typed_parameter",
                                "typed_default_parameter",
                                "identifier"
                            ].contains(&node.kind())
                        )
                        .enumerate()
                        .for_each(|(index, node)| {
                            // If this is a class method then we don't want to add the first
                            // parameter, because that will be the 'self' keyword.
                            if is_class_method && index == 0 {
                                return;
                            }

                            let mut param = Map::new();

                            match node.kind() {
                                "default_parameter" => {
                                    let param_name = node
                                        .children(&mut node.walk())
                                        .next()
                                        .and_then(|node| Some(self.get_node_text(&node)))
                                        .unwrap();
                                    param.insert("name".to_string(), Value::String(param_name));

                                    let param_default_value = node
                                        .children(&mut node.walk())
                                        .last()
                                        .and_then(|node| Some(self.get_node_text(&node)))
                                        .unwrap();
                                    param.insert("default_value".to_string(), Value::String(param_default_value));
                                },
                                "typed_parameter" => {
                                    node.children(&mut node.walk()).for_each(|node| {
                                        if node.kind() == "identifier" {
                                            param.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                                        }

                                        if ["list_splat_pattern", "dictionary_splat_pattern"].contains(&node.kind()) {
                                            let param_name = node
                                                .children(&mut node.walk())
                                                .filter(|node| node.kind() == "identifier")
                                                .next()
                                                .and_then(|node| Some(self.get_node_text(&node)))
                                                .unwrap();
                                            param.insert("name".to_string(), Value::String(param_name));
                                        }

                                        if node.kind() == "type" {
                                            param.insert("type".to_string(), Value::String(self.get_node_text(&node)));
                                        }
                                    });
                                },
                                "typed_default_parameter" => {
                                    let param_name = node
                                        .children(&mut node.walk())
                                        .filter(|node| node.kind() == "identifier")
                                        .next()
                                        .and_then(|node| Some(self.get_node_text(&node)))
                                        .unwrap();
                                    param.insert("name".to_string(), Value::String(param_name));

                                    let param_type = node
                                        .children(&mut node.walk())
                                        .filter(|node| node.kind() == "type")
                                        .next()
                                        .and_then(|node| Some(self.get_node_text(&node)))
                                        .unwrap();
                                    param.insert("type".to_string(), Value::String(param_type));

                                    let param_default_value = node
                                        .children(&mut node.walk())
                                        .filter(|node| node.prev_sibling().is_some())
                                        .filter(|node| node.prev_sibling().unwrap().kind() == "=")
                                        .next()
                                        .and_then(|node| Some(self.get_node_text(&node)))
                                        .unwrap();
                                    param.insert("default_value".to_string(), Value::String(param_default_value));
                                },
                                "identifier" => {
                                    param.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                                },
                                _ => {}
                            }

                            if !param.is_empty() {
                                params.push(Value::Object(param));
                            }
                        });

                    if !params.is_empty() {
                        tokens.insert("params".to_string(), Value::Array(params));
                    }
                },
                "block" => {
                    let exceptions = self.parse_exceptions(&child_node);
                    if !exceptions.is_empty()  {
                        tokens.insert("exceptions".to_string(), Value::Array(exceptions));
                    }
                },
                _ => {},
            }
        }

        Ok(tokens)
    }

    fn parse_exceptions(&self, node: &Node) -> Vec<Value> {
        let mut exceptions = Vec::new();

        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.kind() == "raise_statement" {
                let mut tokens = Map::new();

                let name = child_node
                    .children(&mut child_node.walk())
                    .filter(|node| ["expression_list", "call"].contains(&node.kind()))
                    .next()
                    .and_then(|node| node.children(&mut node.walk()).next())
                    .and_then(|node| Some(self.get_node_text(&node)));

                if name.is_some() {
                    tokens.insert("name".to_string(), Value::String(name.unwrap()));
                } else {
                    tokens.insert("name".to_string(), Value::Null);
                }

                if !tokens.is_empty() {
                    exceptions.push(Value::Object(tokens));
                }
            }
        }

        exceptions
    }
}
