use std::collections::HashMap;

use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::traverse;
use crate::base_parser::BaseParser;
use crate::typescript::parser::TypescriptParser;

pub struct HtmlParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
    options: &'a HashMap<&'a str, bool>,
}

impl<'a> BaseParser for HtmlParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }
}

impl<'a> HtmlParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str], options: &'a HashMap<&'a str, bool>) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_html::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, options, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.kind() == "script_element" {
                return self.parse_script_element(&child_node);
            }
        }

        None
    }

    fn parse_script_element(&self, script_element_node: &Node) -> Option<Result<Map<String, Value>, String>> {
        let raw_text = script_element_node
            .children(&mut script_element_node.walk())
            .filter(|node| node.kind() == "raw_text")
            .next()
            .and_then(|node| Some(self.get_node_text(&node)))
            .unwrap();

        // The new line must be based on the script tag starting position.
        let line = self.line - script_element_node.start_position().row;

        // Parse the inner content of the script tag with the TS parser.
        let ts_parser = TypescriptParser::new(&raw_text, &line, self.node_types, self.options);
        ts_parser.parse()
    }
}
