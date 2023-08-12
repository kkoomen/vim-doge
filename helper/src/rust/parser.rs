use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct RustParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for RustParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }

    /// Decrease the line number as long as it has macros above.
    fn postprocess_line(&self, line: usize) -> usize {
        for node in traverse::PreOrder::new(self.tree.root_node().walk()) {
            if node.start_position().row + 1 == line {
                let mut new_line = line;

                let mut temp_node = node;
                loop {
                    if let Some(sibling_node) = temp_node.prev_sibling() {
                        if sibling_node.kind() != "attribute_item" {
                            break;
                        }

                        new_line = sibling_node.start_position().row + 1;
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

impl<'a> RustParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_rust::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "function_item" => Some(self.parse_function(&child_node)),
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
                "function_modifiers" => {
                    let unsafe_modifier = child_node.children(&mut child_node.walk()).filter(|node| node.kind() == "unsafe").next();
                    if unsafe_modifier.is_some() {
                        tokens.insert("has_unsafe".to_string(), Value::Bool(true));
                    }
                },
                "generic_type" => {
                    let result_enum = child_node.children(&mut child_node.walk())
                        .filter(|node| node.kind() == "type_identifier" && self.get_node_text(&node) == "Result")
                        .next();

                    if result_enum.is_some() {
                        tokens.insert("has_errors".to_string(), Value::Bool(true));
                    }
                },
                "parameters" => {
                    let mut params = Vec::new();

                    child_node
                        .children(&mut child_node.walk())
                        .filter(|node| node.kind() == "parameter")
                        .for_each(|node| {
                            let mut param = Map::new();

                            let func_name = node
                                .children(&mut node.walk())
                                .filter(|node| node.kind() == "identifier")
                                .next()
                                .and_then(|node| Some(self.get_node_text(&node)))
                                .unwrap();
                            param.insert("name".to_string(), Value::String(func_name));

                            params.push(Value::Object(param));
                        });

                    if !params.is_empty() {
                        tokens.insert("params".to_string(), Value::Array(params));
                    }
                },
                "block" => {
                    let has_panics = self.has_panics(&child_node);
                    tokens.insert("has_panics".to_string(), Value::Bool(has_panics));
                },
                _ => {},
            }
        }

        Ok(tokens)
    }

    fn has_panics(&self, node: &Node) -> bool {
        if node.kind() == "macro_invocation" {
            let macro_name = node
                .children(&mut node.walk())
                .filter(|node| node.kind() == "identifier")
                .next()
                .and_then(|node| Some(self.get_node_text(&node)))
                .unwrap();

            if macro_name == "panic" {
                return true;
            }
        }

        for child_node in node.children(&mut node.walk()) {
            if self.has_panics(&child_node) {
                return true;
            }
        }

        false
    }
}
