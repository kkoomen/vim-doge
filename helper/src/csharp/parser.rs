use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct CSharpParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for CSharpParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }
}

impl<'a> CSharpParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_c_sharp::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "method_declaration" |
                    "operator_declaration" |
                    "delegate_declaration" |
                    "constructor_declaration" => Some(self.parse_function(&child_node)),

                    "class_declaration" |
                    "variable_declaration" |
                    "property_declaration" |
                    "field_declaration" |
                    "enum_declaration" => self.empty_parse_result(),

                    _ => None,
                };
            }
        }

        None
    }

    fn parse_function(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        if node.kind() == "constructor_declaration" {
            tokens.insert("is_constructor".to_string(), Value::Bool(true));
        }

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "void_keyword" | "predefined_type" => {
                    let return_type = self.get_node_text(&child_node);
                    if return_type == "void" {
                        tokens.insert("has_non_void_return_type".to_string(), Value::Bool(false));
                    }
                }
                "parameter_list" => {
                    let mut params = Vec::new();

                    child_node
                        .children(&mut child_node.walk())
                        .filter(|node| node.kind() == "parameter")
                        .for_each(|node| {
                            let mut param = Map::new();

                            let param_name = node
                                .children(&mut node.walk())
                                .filter(|node| node.kind() == "identifier")
                                .last()
                                .and_then(|node| Some(self.get_node_text(&node)))
                                .unwrap();
                            param.insert("name".to_string(), Value::String(param_name));

                            if !param.is_empty() {
                                params.push(Value::Object(param));
                            }
                        });

                    if !params.is_empty() {
                        tokens.insert("params".to_string(), Value::Array(params));
                    }
                },
                _ => {},
            }
        }

        // Return types are mandatory in csharp. If we didn't come across a void
        // keyword when traversing the function node tree, then it does not have
        // a void return type, thus we set the corresponding token to be false.
        if tokens.get("has_non_void_return_type").is_none() {
            tokens.insert("has_non_void_return_type".to_string(), Value::Bool(true));
        }

        Ok(tokens)
    }
}
