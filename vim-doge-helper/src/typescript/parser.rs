use tree_sitter::{Parser, Node};
use serde_json::{Map, Value};

use crate::base_parser::BaseParser;
use crate::traverse;

pub struct TypescriptParser<'a> {
    code: &'a str,
    tree: tree_sitter::Tree,
    line: &'a usize,
    node_types: &'a [&'a str],
}

impl<'a> BaseParser for TypescriptParser<'a> {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>> {
        self.parse_node(&self.tree.root_node())
    }

    fn get_code_bytes(&self) -> &[u8] {
        &self.code.as_bytes()
    }

    /// Decrease the line number as long as it has a decorator above it.
    fn postprocess_line(&self, line: usize) -> usize {
        for node in traverse::PreOrder::new(self.tree.root_node().walk()) {
            if node.start_position().row + 1 == line {
                let mut new_line = line;

                let mut temp_node = node;
                loop {
                    if let Some(sibling_node) = temp_node.prev_sibling() {
                        if sibling_node.kind() != "decorator" {
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

impl<'a> TypescriptParser<'a> {
    pub fn new(code: &'a str, line: &'a usize, node_types: &'a [&'a str]) -> Self {
        let mut parser = Parser::new();
        parser.set_language(tree_sitter_typescript::language_tsx()).unwrap();

        let tree = parser.parse(code, None).unwrap();

        Self { code, tree, line, node_types }
    }

    fn parse_node(&self, node: &Node) -> Option<Result<Map<String, Value>, String>> {
        for child_node in traverse::PreOrder::new(node.walk()) {
            if child_node.start_position().row + 1 == *self.line && self.node_types.contains(&child_node.kind()) {
                return match child_node.kind() {
                    "arrow_function" |
                    "function" |
                    "function_declaration" |
                    "function_signature" |
                    "generator_function" |
                    "generator_function_declaration" |
                    "method_definition" => Some(self.parse_function(&child_node)),

                    "member_expression" => Some(self.parse_member_expression(&child_node)),

                    "class" | "class_declaration" => Some(self.parse_class(&child_node)),

                    _ => None,
                };
            }
        }

        None
    }

    fn parse_class(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "type_identifier" => {
                    tokens.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                },
                "type_params" => {
                    let tparams = self.parse_func_tparams(&child_node);
                    if !tparams.is_empty() {
                        tokens.insert("tparams".to_string(), Value::Array(tparams));
                    }
                },
                "class_heritage" => {
                    child_node.children(&mut child_node.walk()).for_each(|node| {
                        if node.kind() == "extends_clause" {
                            let parent_name = node
                                .children(&mut node.walk())
                                .filter(|node|
                                    [
                                        "member_expression",
                                        "identifier"
                                    ].contains(&node.kind())
                                )
                                .next()
                                .and_then(|node| Some(self.get_node_text(&node)))
                                .unwrap();
                            tokens.insert("parent_name".to_string(), Value::String(parent_name));
                        }

                        if node.kind() == "implements_clause" {
                            node.children(&mut node.walk()).for_each(|node| {
                                if node.kind() == "generic_type" {
                                    let interface_name = node
                                        .children(&mut node.walk())
                                        .filter(|node| node.kind() == "type_identifier")
                                        .next()
                                        .and_then(|node| Some(self.get_node_text(&node)))
                                        .unwrap();
                                    tokens.insert("interface_name".to_string(), Value::String(interface_name));
                                }

                                if node.kind() == "type_identifier" {
                                    tokens.insert("interface_name".to_string(), Value::String(self.get_node_text(&node)));
                                }
                            })
                        }
                    })
                },
                _ => {},
            }
        }

        Ok(tokens)
    }

    fn parse_member_expression(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut tokens = Map::new();

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "member_expression" => {
                    let func_name = child_node
                        .children(&mut child_node.walk())
                        .next()
                        .and_then(|node| Some(self.get_node_text(&node)))
                        .unwrap();
                    tokens.insert("function_name".to_string(), Value::String(func_name));
                },
                "property_identifier" => {
                    tokens.insert("property_name".to_string(), Value::String(self.get_node_text(&child_node)));
                },
                _ => {},
            }
        }

        if let Some(parent) = node.parent() {
            let func_node = parent.children(&mut parent.walk()).last();
            match self.parse_function(&func_node.unwrap()) {
                Ok(func_tokens) => { tokens.extend(func_tokens) },
                Err(_) => {},
            }
        }

        Ok(tokens)
    }

    fn parse_function(&self, node: &Node) -> Result<Map<String, Value>, String> {
        let mut is_single_param_arrow_func = false;
        let mut tokens = Map::new();

        if ["generator_function", "generator_function_declaration"].contains(&node.kind()) {
            tokens.insert("generator".to_string(), Value::Bool(true));
        }

        // handle scenario: const foo = (bar) => bar;
        if let Some(arrow_func_tokens) = self.parse_single_param_arrow_func(&node) {
            tokens.extend(arrow_func_tokens);
            is_single_param_arrow_func = true;
        }

        for child_node in node.children(&mut node.walk()) {
            match child_node.kind() {
                "property_identifier" | "identifier" => {
                    if child_node.parent().unwrap().parent().unwrap().kind() == "variable_declarator" {
                        tokens.insert("name".to_string(), Value::String(self.get_node_text(&child_node)));
                    }
                },
                "async" => {
                    tokens.insert("async".to_string(), Value::Bool(true));
                },
                "static" => {
                    tokens.insert("static".to_string(), Value::Bool(true));
                },
                "statement_block" | "class_body" => {
                    let exceptions = self.parse_exceptions(&child_node);
                    if !exceptions.is_empty()  {
                        tokens.insert("exceptions".to_string(), Value::Array(exceptions));
                    }

                    // tokens.insert("has_return_statement_value".to_string(), self.has_return_statement_value(&child_node));
                }
                "type_annotation" => {
                    let return_type = child_node
                        .children(&mut child_node.walk())
                        .filter(|node| node.kind() != ":")
                        .next()
                        .and_then(|node| Some(self.get_node_text(&node)))
                        .unwrap();

                    if return_type != "void" {
                        tokens.insert("return_type".to_string(), Value::String(return_type));
                    }
                }
                "type_parameters" => {
                    let tparams = self.parse_func_tparams(&child_node);
                    if !tparams.is_empty() {
                        tokens.insert("tparams".to_string(), Value::Array(tparams));
                    }
                },
                "formal_parameters" => {
                    if !is_single_param_arrow_func {
                        let params = self.parse_func_params(&child_node);
                        if !params.is_empty() {
                            tokens.insert("params".to_string(), Value::Array(params));
                        }
                    }
                }
                _ => {},
            }
        }

        Ok(tokens)
    }

    fn parse_exceptions(&self, node: &Node) -> Vec<Value> {
        let mut exceptions = Vec::new();

        if node.kind() == "throw_statement" {
            let mut tokens = Map::new();

            let name = node
                .children(&mut node.walk())
                .filter(|node| ["new_expression"].contains(&node.kind()))
                .next()
                .and_then(|node|
                    node.children(&mut node.walk())
                        .filter(|node| node.kind() == "identifier")
                        .next()
                )
                .and_then(|node| Some(self.get_node_text(&node)));

            if name.is_some() {
                tokens.insert("name".to_string(), Value::String(name.unwrap()));
            } else {
                tokens.insert("name".to_string(), Value::Null);
            }

            if !tokens.is_empty() {
                exceptions.push(Value::Object(tokens));
            }
        }

        for child_node in node.children(&mut node.walk()) {
            exceptions.extend(self.parse_exceptions(&child_node));
        }

        exceptions
    }

    fn parse_func_destruct_params(&self, node: &Node) -> Vec<Value> {
        let mut subparams = Vec::new();

        node
            .children(&mut node.walk())
            .filter(|node|
                [
                    "pair_pattern",
                    "shorthand_property_identifier_pattern",
                    "object_assignment_pattern",
                ].contains(&node.kind())
            )
            .for_each(|node| {
                let mut subparam = Map::new();

                match node.kind() {
                    "shorthand_property_identifier_pattern" => {
                        subparam.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                    },
                    "object_assignment_pattern" => {
                        let subparam_name = node
                            .children(&mut node.walk())
                            .next()
                            .and_then(|node| Some(self.get_node_text(&node)))
                            .unwrap();
                        subparam.insert("name".to_string(), Value::String(subparam_name));
                        subparam.insert("optional".to_string(), Value::Bool(true));
                    },
                    "pair_pattern" =>{
                        let subparam_name = node
                            .children(&mut node.walk())
                            .next()
                            .and_then(|node| Some(self.get_node_text(&node)))
                            .unwrap();
                        subparam.insert("name".to_string(), Value::String(subparam_name));

                        let param_type_child = node.children(&mut node.walk()).last().unwrap();
                        if param_type_child.kind() == "assignment_pattern" {
                            let subparam_type = param_type_child
                                .children(&mut param_type_child.walk())
                                .next()
                                .and_then(|node| Some(self.get_node_text(&node)))
                                .unwrap();
                            subparam.insert("type".to_string(), Value::String(subparam_type));

                            let subparam_default_value = param_type_child
                                .children(&mut param_type_child.walk())
                                .last()
                                .and_then(|node| Some(self.get_node_text(&node)))
                                .unwrap();
                            subparam.insert("default_value".to_string(), Value::String(subparam_default_value));

                            subparam.insert("optional".to_string(), Value::Bool(true));
                        } else {
                            subparam.insert("type".to_string(), Value::String(self.get_node_text(&param_type_child)));
                        }
                    },
                    _ => {}
                }

                if !subparam.is_empty() {
                    let subparam_name = format!("[TODO:name].{}", subparam.get("name").unwrap().as_str().unwrap());
                    subparam.insert("name".to_string(), Value::String(subparam_name));
                    subparams.push(Value::Object(subparam));
                }
            });

        subparams
    }

    fn parse_func_params(&self, node: &Node) -> Vec<Value> {
        let mut params = Vec::new();

        node
            .children(&mut node.walk())
            .filter(|node|
                [
                    "required_parameter",
                    "rest_parameter",
                    "optional_parameter"
                ].contains(&node.kind())
            )
            .for_each(|node| {
                let mut subparams = Vec::new();
                let mut param = Map::new();
                param.insert("optional".to_string(), Value::Bool(node.kind() == "optional_parameter"));

                node.children(&mut node.walk()).for_each(|node| {
                    match node.kind() {
                        "identifier" => {
                            param.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                        },
                        "rest_pattern" => {
                            let param_name = node
                                .children(&mut node.walk())
                                .last()
                                .and_then(|node| Some(self.get_node_text(&node)))
                                .unwrap();
                            param.insert("name".to_string(), Value::String(param_name));
                        },
                        "type_annotation" => {
                            let param_type = node
                                .children(&mut node.walk())
                                .filter(|node| ![":", "object_type"].contains(&node.kind()))
                                .next()
                                .and_then(|node| Some(self.get_node_text(&node)));

                            if param_type.is_some() {
                                param.insert("type".to_string(), Value::String(param_type.unwrap()));
                            }
                        },
                        "object_pattern" => {
                            // Check for destructuring patterns.
                            subparams.extend(self.parse_func_destruct_params(&node));
                        },
                        _ => {},
                    }

                    if let Some(prev_sibling_node) = node.prev_sibling() {
                        if prev_sibling_node.kind() == "=" {
                            param.insert("default".to_string(), Value::String(self.get_node_text(&node)));
                            param.insert("optional".to_string(), Value::Bool(true));
                        }
                    }
                });


                if !param.is_empty() {
                    params.push(Value::Object(param));
                }

                params.extend(subparams);
            });

        params
    }

    fn parse_func_tparams(&self, node: &Node) -> Vec<Value> {
        let mut tparams = Vec::new();

        node.children(&mut node.walk())
            .filter(|node| node.kind() == "type_parameter")
            .for_each(|node| {
                let mut tparam = Map::new();

                node.children(&mut node.walk()).for_each(|node| {
                    if node.kind() == "type_identifier" {
                        tparam.insert("name".to_string(), Value::String(self.get_node_text(&node)));
                    }

                    if node.kind() == "default_type" {
                        let default_value = node
                            .children(&mut node.walk())
                            .last()
                            .and_then(|node| Some(self.get_node_text(&node)))
                            .unwrap();
                        tparam.insert("default_value".to_string(), Value::String(default_value));
                    }
                });

                if !tparam.is_empty() {
                    tparams.push(Value::Object(tparam));
                }
            });

        tparams
    }

    fn parse_single_param_arrow_func(&self, node: &Node) -> Option<Map<String, Value>> {
        let parent_node = node.parent().unwrap();
        if ["arrow_function", "function"].contains(&node.kind()) && parent_node.kind() == "variable_declarator" {
            let mut tokens = Map::new();

            let func_name = parent_node.children(&mut parent_node.walk()).next().unwrap();
            tokens.insert("name".to_string(), Value::String(self.get_node_text(&func_name)));

            // handle scenario: const foo = bar => bar;
            if node.children(&mut node.walk()).next().unwrap().kind() == "identifier" {
                let param_name = node
                    .children(&mut node.walk())
                    .next()
                    .and_then(|node| Some(self.get_node_text(&node)))
                    .unwrap();

                let mut params = Vec::new();
                let mut param = Map::new();
                param.insert("name".to_string(), Value::String(param_name));
                params.push(Value::Object(param));
                tokens.insert("params".to_string(), Value::Array(params));
            }

            return Some(tokens);
        }

        None
    }
}
