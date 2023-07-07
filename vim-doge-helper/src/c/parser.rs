use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct CParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for CParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }
}

impl<'a> CParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_c::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "function_definition" | "declaration" => Some(self.parse_function(&child_node)),
                    "struct_specifier" => Some(self.parse_struct(&child_node)),
                    "field_declaration" => Some(self.parse_field_declaration(&child_node)),
                    _ => None,
                };
            }
        }

        None
    }

    fn parse_function_params(&self, node: &Node) -> Vec<Value> {
        let mut params = Vec::new();

        for child_node in node.children(&mut node.walk()) {
            child_node
                .children(&mut child_node.walk())
                .filter(|node| ["parameter_list", "parameter_declaration"].contains(&node.kind()))
                .for_each(|node| {
                    let mut param = Map::new();

                    let param_name = node
                        .children(&mut node.walk())
                        .filter(|node| node.kind() == "identifier")
                        .next()
                        .and_then(|node| Some(self.get_node_text(&node)));

                    if param_name.is_some() {
                        param.insert("name".to_string(), Value::String(param_name.unwrap()));
                    }

                    if !param.is_empty() {
                        params.push(Value::Object(param));
                    }
                });
        }

        params
    }

    fn parse_function(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "primitive_type" | "type_identifier" => {
                    let return_type = self.get_node_text(&child_node);
                    if return_type != "void" {
                        tokens.insert("return_type".to_string(), Value::String(return_type));
                    }
                },
                "pointer_declarator" => {
                    tokens.extend(self.parse_function(&child_node).unwrap());
                },
                "function_declarator" => {
                    let func_name = child_node
                        .children(&mut child_node.walk())
                        .filter(|node| ["identifier", "parenthesized_declarator"].contains(&node.kind()))
                        .next()
                        .and_then(|node| {
                            if node.kind() == "parenthesized_declarator" {
                                let name = node
                                    .children(&mut node.walk())
                                    .filter(|node| node.kind() == "pointer_declarator")
                                    .next()
                                    .and_then(|node| node.children(&mut node.walk()).last())
                                    .and_then(|node| Some(self.get_node_text(&node)))
                                    .unwrap();

                                return Some(name);
                            }

                            Some(self.get_node_text(&node))
                        })
                        .unwrap();

                    tokens.insert("name".to_string(), Value::String(func_name));

                    let params = self.parse_function_params(&child_node);
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

}
