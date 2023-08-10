use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse::{self, PreOrder};

pub struct CppParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for CppParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node(), self.line)
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }

    /// Decrease the line number as long as it has a template statement above.
    fn postprocess_line(&self, line: usize) -> usize {
        for node in traverse::PreOrder::new(self.tree.root_node().walk()) {
            if node.start_position().row + 1 == line {
                let mut new_line = line;

                let mut temp_node = node;
                loop {
                    if let Some(sibling_node) = temp_node.prev_sibling() {
                        if sibling_node.kind() != "template_parameter_list" {
                            break;
                        }

                        new_line -= 1;
                        temp_node = sibling_node;
                    } else {
                      break;
                    }
                }

                return new_line;
            }
        }

        line
    }
}

impl<'a> CppParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_cpp::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node, line: &usize) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "template_declaration" => self.parse_template_declaration(&child_node),
                    "function_declarator" => Some(self.parse_function(&child_node.parent().unwrap())),
                    "function_definition" | "declaration" => Some(self.parse_function(&child_node)),
                    "struct_specifier" => Some(self.parse_struct(&child_node)),
                    "field_declaration" => Some(self.parse_field_declaration(&child_node)),
                    "class_specifier" => Some(self.parse_class(&child_node)),
                    _ => None,
                };
            }
        }

        None
    }

    fn parse_template_declaration(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        let child_node = node
            .children(&mut node.walk())
            .filter(|node| {
                if let Some(prev_sibling_node) = node.prev_sibling() {
                    return prev_sibling_node.kind() == "template_parameter_list"
                }

                false
            })
            .last()
            .unwrap();

        let new_line_num = child_node.start_position().row + 1;
        return self.parse_node(&child_node, &new_line_num);
    }

    fn parse_tparams(&self, node: &Node) -> Vec<Value> {
        let mut tparams = Vec::new();

        let tparams_list_node = node
            .children(&mut node.walk())
            .filter(|node| node.kind() == "template_parameter_list")
            .next()
            .unwrap();

        tparams_list_node
            .children(&mut tparams_list_node.walk())
            .filter(|node|
                [
                    "type_parameter_declaration",
                    "parameter_declaration",
                    "variadic_type_parameter_declaration"
                ].contains(&node.kind())
            ).for_each(|node| {
                let mut tparam = Map::new();

                let tparam_name = node
                    .children(&mut node.walk())
                    .filter(|node| ["type_identifier", "identifier"].contains(&node.kind()))
                    .next()
                    .and_then(|node| Some(self.get_node_text(&node)))
                    .unwrap();
                tparam.insert("name".to_string(), Value::String(tparam_name));

                tparams.push(Value::Object(tparam));
            });

        tparams
    }

    fn parse_params(&self, node: &Node) -> Vec<Value> {
        let mut params = Vec::new();

        let params_node = node
            .children(&mut node.walk())
            .filter(|node| ["parameter_list", "parameter_declaration"].contains(&node.kind()))
            .next()
            .unwrap();

        params_node
            .children(&mut params_node.walk())
            .filter(|node|
                [
                    "parameter_declaration",
                    "scoped_type_identifier",
                    "optional_parameter_declaration",
                    "variadic_parameter_declaration",
                ].contains(&node.kind())
            ).for_each(|node| {
                let mut param = Map::new();

                node.children(&mut node.walk()).for_each(|node| {
                    if ["primitive_type", "type_identifier"].contains(&node.kind()) {
                        param.insert("type".to_string(), Value::String(self.get_node_text(&node)));
                    }

                    if ["pointer_declarator", "reference_declarator", "variadic_declarator"].contains(&node.kind()) {
                        for node in PreOrder::new(node.walk()) {
                            if node.kind() == "identifier" {
                                param.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                            }
                        }
                    }

                    if node.kind() == "identifier" {
                        param.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                    }
                });

                params.push(Value::Object(param));
            });

        params
    }

    fn parse_function(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        let parent_node = node.parent().unwrap();
        if parent_node.kind() == "template_declaration" {
            let tparams = self.parse_tparams(&parent_node);
            if !tparams.is_empty() {
                tokens.insert("tparams".to_string(), Value::Array(tparams));
            }
        }

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "auto" | "primitive_type" | "type_identifier" => {
                    let return_type = self.get_node_text(&child_node);
                    if return_type != "void" {
                        tokens.insert("return_type".to_string(), Value::String(return_type));
                    }
                },
                "pointer_declarator" => {
                  tokens.extend(self.parse_function(&child_node).unwrap());
                },
                "function_declarator" => {
                    // Return type for statement like:
                    //   auto Person::getPersonType () -> PersonType

                    let auto_return_node = child_node
                        .children(&mut child_node.walk())
                        .filter(|node| node.kind() == "trailing_return_type")
                        .next();
                    if auto_return_node.is_some() {
                        let return_type = auto_return_node.unwrap()
                            .children(&mut auto_return_node.unwrap().walk())
                            .last()
                            .and_then(|node| Some(self.get_node_text(&node)))
                            .unwrap();
                        tokens.insert("return_type".to_string(), Value::String(return_type));
                    }

                    // Method name.
                    child_node
                        .children(&mut child_node.walk())
                        .filter(|node|
                            [
                                "identifier",
                                "scoped_identifier",
                                "field_identifier"
                            ].contains(&node.kind())
                        )
                        .for_each(|node| {
                            if ["identifier", "field_identifier"].contains(&node.kind()) {
                                tokens.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                            }

                            if node.kind() == "scoped_identifier" {
                                let method_name = node
                                    .children(&mut node.walk())
                                    .last()
                                    .and_then(|node| Some(self.get_node_text(&node)))
                                    .unwrap();
                                tokens.insert("name".to_string(), Value::String(method_name));
                            }
                        });

                    let params = self.parse_params(&child_node);
                    if !params.is_empty() {
                        tokens.insert("params".to_string(), Value::Array(params));
                    }
                },
                _ => {},
            }
        }

        Ok(tokens)
    }

    fn parse_struct(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        let parent_node = node.parent().unwrap();
        if parent_node.kind() == "template_declaration" {
            let tparams = self.parse_tparams(&parent_node);
            if !tparams.is_empty() {
                tokens.insert("tparams".to_string(), Value::Array(tparams));
            }
        }

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "type_identifier" => {
                    tokens.insert("name".to_string(), Value::String(self.get_node_text(&child_node)));
                },
                _ => {}
            }
        }

        Ok(tokens)
    }

    fn parse_field_declaration(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "field_identifier" => {
                    tokens.insert("name".to_string(), Value::String(self.get_node_text(&child_node)));
                },
                _ => {}
            }
        }

        Ok(tokens)
    }

    fn parse_class(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        let parent_node = node.parent().unwrap();
        if parent_node.kind() == "template_declaration" {
            let tparams = self.parse_tparams(&parent_node);
            if !tparams.is_empty() {
                tokens.insert("tparams".to_string(), Value::Array(tparams));
            }
        }

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "type_identifier" => {
                    tokens.insert("name".to_string(), Value::String(self.get_node_text(&child_node)));
                },
                _ => {}
            }
        }

        Ok(tokens)
    }

}
