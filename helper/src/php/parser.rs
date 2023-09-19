use std::collections::HashMap;

use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct PhpParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
    options: &'a HashMap<&'a str, bool>,
}

impl<'a> BaseParser for PhpParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }
}

impl<'a> PhpParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str], options: &'a HashMap<&str, bool>) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_php::language()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types, options }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "function_definition" | "method_declaration" => Some(self.parse_function(&child_node)),
                    "property_declaration" => Some(self.parse_class_property(&child_node)),
                    _ => None,
                };
            }
        }

        None
    }

    fn get_class_property_type_via_constructor(&self, node: &Node) -> Option<String> {
        let property_name_node = node.children(&mut node.walk())
            .filter(|node| node.kind() == "property_element")
            .next()
            .and_then(|node| node.children(&mut node.walk()).next())
            .and_then(|node| node.children(&mut node.walk()).last());

        if property_name_node.is_none() {
            return None;
        }

        let parent_node = &node.parent().unwrap();
        let constructor_node = &parent_node
            .children(&mut parent_node.walk())
            .filter(|node| node.kind() == "method_declaration")
            .filter(|node| {
                let method_name = node
                    .children(&mut node.walk())
                    .filter(|c| c.kind() == "name")
                    .next()
                    .and_then(|node| Some(self.get_node_text(&node)))
                    .unwrap();
                return method_name == "__construct";
            })
            .next();

        if constructor_node.is_none() {
            return None;
        }

        // Look for the $this->var expression to get the param name
        let param_name = constructor_node.unwrap()
            .children(&mut constructor_node.unwrap().walk())
            .filter(|node| node.kind() == "compound_statement")
            .next()
            .and_then(|node| {
                let cursor = &mut node.walk();
                let nodes = node.children(cursor).filter(|node| node.kind() == "expression_statement");
                let mut value = None;

                for node in nodes {
                    let expr_node = node
                        .children(&mut node.walk())
                        .filter(|node| node.kind() == "assignment_expression")
                        .next()
                        .unwrap();

                    let prop_name = expr_node
                        .children(&mut expr_node.walk())
                        .filter(|node| node.kind() == "member_access_expression")
                        .next()
                        .and_then(|node| node.children(&mut node.walk()).last())
                        .and_then(|node| Some(self.get_node_text(&node)));

                    if prop_name.unwrap() == self.get_node_text(&property_name_node.unwrap()) {
                        value = expr_node
                            .children(&mut expr_node.walk())
                            .filter(|node| node.kind() == "variable_name")
                            .next()
                            .and_then(|node| Some(self.get_node_text(&node)));
                        break;
                    }
                }

                value
            });

        if param_name.is_none() {
            return None;
        }

        let param_type = constructor_node.unwrap()
            .children(&mut constructor_node.unwrap().walk())
            .filter(|node| node.kind() == "formal_parameters")
            .next()
            .and_then(|node|
                node.children(&mut node.walk())
                    .filter(|node| node.kind() == "simple_parameter")
                    .filter(|node| {
                        let name = node
                            .children(&mut node.walk())
                            .filter(|node| node.kind() == "variable_name")
                            .next()
                            .and_then(|node| Some(self.get_node_text(&node)));
                        return name == param_name;
                    })
                    .next()
            )
            .and_then(|node|{
                return node
                    .children(&mut node.walk())
                    .filter(|node| node.kind() == "union_type")
                    .next()
                    .and_then(|node| Some(self.get_node_text(&node)))
            });

        param_type
    }

    fn resolve_fqn(&self, property_type: &str) -> String {
        let mut fqn = property_type.to_string();

        if self.options["resolve_fqn"] {
            self.tree.root_node()
                .children(&mut self.tree.root_node().walk())
                .filter(|node| node.kind() == "namespace_use_declaration")
                .for_each(|node| {
                    let cursor = &mut node.walk();
                    let children = node.children(cursor).filter(|node| node.kind() == "namespace_use_clause");

                    for child_node in children {
                        let is_alias = child_node
                            .children(&mut child_node.walk())
                            .filter(|node| node.kind() == "namespace_aliasing_clause")
                            .count() > 0;

                        if !is_alias {
                            // Get the `qualified_name` node kind, which are
                            // usages like: `use Foo\Bar;`. We might also run
                            // into `use Foo;` which has the node kind `name`,
                            // which we ignore.
                            let fqn_node = child_node
                                .children(&mut child_node.walk())
                                .filter(|node| node.kind() == "qualified_name")
                                .next();

                            if !fqn_node.is_some() {
                                continue;
                            }

                            let fqn_name = fqn_node
                                .unwrap()
                                .children(&mut fqn_node.unwrap().walk())
                                .filter(|node| node.kind() == "name")
                                .next()
                                .and_then(|node| Some(self.get_node_text(&node)));

                            if fqn_name.unwrap() == property_type {
                                let mut fqn_text = self.get_node_text(&fqn_node.unwrap());

                                // Make sure FQN always starts with a backslash.
                                if !fqn_text.starts_with('\\') {
                                    fqn_text.insert(0, '\\');
                                }

                                fqn = fqn_text;
                                break;
                            }
                        }
                    }
                });
        }

        fqn
    }

    fn parse_class_property(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        if let Some(property_type) = self.get_class_property_type_via_constructor(&node) {
            tokens.insert("type".to_string(), Value::String(self.resolve_fqn(&property_type)));
        }

        Ok(tokens)
    }

    fn resolve_type_hint(&self, type_hint: String) -> String {
        let mut new_type_hint = type_hint.clone();

        // Return type like ?array indicate it could be an array,
        // but it could be null as well, so when the type starts
        // with a question mark, then we should also append the
        // possibility to be null.
        if new_type_hint.starts_with("?") {
            new_type_hint.remove(0);
            new_type_hint = self.resolve_fqn(&new_type_hint);
            new_type_hint.push_str("|null");
        } else {
            new_type_hint = self.resolve_fqn(&new_type_hint)
        }

        return new_type_hint;
    }

    fn parse_function(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "name" => {
                    let func_name = self.get_node_text(&child_node);
                    if func_name == "__construct" {
                        tokens.insert("is_constructor_method".to_string(), Value::Bool(true));
                    }
                },
                "union_type" => {
                    let return_type = self.resolve_type_hint(self.get_node_text(&child_node));
                    tokens.insert("return_type".to_string(), Value::String(return_type));
                },
                "formal_parameters" => {
                    let mut params = Vec::new();

                    for param_child_node in child_node.children(&mut child_node.walk()).filter(|n| n.kind() == "simple_parameter") {
                        let mut param = Map::new();

                        for param_grandchild_node in param_child_node.children(&mut param_child_node.walk()) {
                            // Get param type.
                            if param_grandchild_node.kind() == "union_type" {
                                let param_type = self.resolve_type_hint(self.get_node_text(&param_grandchild_node));
                                param.insert("type".to_string(), Value::String(self.resolve_fqn(&param_type)));
                            }

                            // Get param name.
                            if param_grandchild_node.kind() == "variable_name" {
                                param.insert("name".to_string(), Value::String(self.get_node_text(&param_grandchild_node)));
                            }

                            // Get param default value.
                            if param_grandchild_node.prev_sibling().is_some() {
                                if param_grandchild_node.prev_sibling().unwrap().kind() == "=" {
                                    param.insert("default_value".to_string(), Value::String(self.get_node_text(&param_grandchild_node)));
                                }
                            }

                        }

                        if !param.is_empty() {
                            params.push(Value::Object(param));
                        }
                    }

                    tokens.insert("params".to_string(), Value::Array(params));
                },
                "compound_statement" => {
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
            if child_node.kind() == "object_creation_expression" {
                let mut tokens = Map::new();

                let name = child_node
                    .children(&mut child_node.walk())
                    .filter(|node| node.kind() == "name")
                    .next()
                    .and_then(|node| Some(self.get_node_text(&node)))
                    .unwrap();

                let prev_sibling_node = &child_node.prev_sibling();

                if name.ends_with("Exception") || (prev_sibling_node.is_some() && prev_sibling_node.unwrap().kind() == "throw") {
                    tokens.insert("name".to_string(), Value::String(name));
                }

                if !tokens.is_empty()  {
                    exceptions.push(Value::Object(tokens));
                }
            }

        }

        exceptions
    }
}
