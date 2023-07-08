use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct LuaParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for LuaParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }
}

impl<'a> LuaParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_lua::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "function_definition_statement" | "function_definition" => Some(self.parse_function(&child_node)),
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
                "parameter_list" => {
                    let mut params = Vec::new();

                    child_node
                        .children(&mut child_node.walk())
                        .filter(|node| node.kind() == "identifier")
                        .for_each(|node| {
                            let mut param = Map::new();

                            let func_name = self.get_node_text(&node);
                            if func_name != "self" {
                                param.insert("name".to_string(), Value::String(func_name));
                            }

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

        Ok(tokens)
    }
}
