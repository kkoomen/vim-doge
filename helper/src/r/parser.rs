use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct RParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for RParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }
}

impl<'a> RParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_r::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "function_definition" => Some(self.parse_function(&child_node)),
                    _ => None,
                };
            }
        }

        None
    }

    fn parse_function(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        if let Some(parent_node) = node.parent() {
            let func_name = parent_node
                .children(&mut parent_node.walk())
                .filter(|node| node.kind() == "identifier")
                .next()
                .and_then(|node| Some(self.get_node_text(&node)))
                .unwrap();
            tokens.insert("func_name".to_string(), Value::String(func_name));
        }

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "formal_parameters" => {
                    let mut params = Vec::new();

                    for grandchild_node in child_node.children(&mut child_node.walk()) {
                        let mut param = Map::new();

                        match grandchild_node.kind() {
                            "identifier" | "dots" => {
                                param.insert("name".to_string(), Value::String(self.get_node_text(&grandchild_node)));
                            },
                            "default_parameter" => {
                                let name = grandchild_node
                                    .children(&mut grandchild_node.walk())
                                    .filter(|node| node.kind() == "identifier")
                                    .next()
                                    .and_then(|node| Some(self.get_node_text(&node)))
                                    .unwrap();

                                let default_value = grandchild_node
                                    .children(&mut grandchild_node.walk())
                                    .filter(|node| node.kind() == "=")
                                    .next()
                                    .unwrap()
                                    .next_sibling()
                                    .and_then(|node| Some(self.get_node_text(&node)))
                                    .unwrap();

                                param.insert("name".to_string(), Value::String(name));
                                param.insert("default_value".to_string(), Value::String(default_value));
                            },
                            _ => {},
                        }

                        if !param.is_empty() {
                            params.push(Value::Object(param));
                        }
                    }

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
