use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct RubyParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for RubyParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }
}

impl<'a> RubyParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_ruby::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "method" | "singleton_method" => Some(self.parse_function(&child_node)),
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
                "method_parameters" => {
                    let mut params = Vec::new();

                    child_node
                        .children(&mut child_node.walk())
                        .filter(|node|
                            [
                                "identifier",
                                "optional_parameter",
                                "splat_parameter",
                                "hash_splat_parameter",
                                "block_parameter",
                                "keyword_parameter"
                            ].contains(&node.kind())
                        )
                        .for_each(|node| {
                            let mut param = Map::new();

                            if node.kind() == "identifier" {
                                param.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                            }

                            if ["optional_parameter", "keyword_parameter"].contains(&node.kind()) {
                                let child_node = node.children(&mut node.walk()).next().unwrap();
                                let param_name = self.get_node_text(&child_node);
                                param.insert("name".to_string(), Value::String(param_name));
                            }

                            if ["splat_parameter", "hash_splat_parameter", "block_parameter"].contains(&node.kind()) {
                                let child_node = node.children(&mut node.walk()).last().unwrap();
                                let param_name = self.get_node_text(&child_node);
                                param.insert("name".to_string(), Value::String(param_name));
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
