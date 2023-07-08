use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct JavaParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for JavaParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }
}

impl<'a> JavaParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_java::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "method_declaration" => Some(self.parse_function(&child_node)),
                    _ => None,
                };
            }
        }

        None
    }

    fn parse_function(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "type_identifier" |
                "void_type" |
                "floating_point_type" |
                "array_type" |
                "boolean_type" |
                "integral_type" |
                "generic_type" => {
                    let return_type = self.get_node_text(&child_node);
                    if return_type != "void" {
                        tokens.insert("return_type".to_string(), Value::String(return_type));
                    }
                },
                "throws" => {
                    let mut exceptions = Vec::new();

                    child_node
                        .children(&mut child_node.walk())
                        .filter(|node| node.kind() == "type_identifier")
                        .for_each(|node| {
                            let mut exception = Map::new();

                            exception.insert("name".to_string(), Value::String(self.get_node_text(&node)));

                            exceptions.push(Value::Object(exception));
                        });

                    if !exceptions.is_empty() {
                        tokens.insert("exceptions".to_string(), Value::Array(exceptions));
                    }
                },
                "formal_parameters" => {
                    let mut params = Vec::new();

                    child_node
                        .children(&mut child_node.walk())
                        .filter(|node| ["formal_parameter", "spread_parameter"].contains(&node.kind()))
                        .for_each(|node| {
                            let mut param = Map::new();

                            let param_type_node = node.children(&mut node.walk()).next().unwrap();
                            param.insert("type".to_string(), Value::String(self.get_node_text(&param_type_node)));

                            let param_name_node = node.children(&mut node.walk()).last().unwrap();
                            param.insert("name".to_string(), Value::String(self.get_node_text(&param_name_node)));

                            params.push(Value::Object(param));
                        });

                    if !params.is_empty() {
                        tokens.insert("params".to_string(), Value::Array(params));
                    }
                },
                _ => {},
            }
        }

        Ok(tokens)
    }
}
