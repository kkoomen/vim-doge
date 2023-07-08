use std::collections::HashMap;

use serde_json::{Map, Value, json};

use crate::config::load_doc_config_str;

use crate::base_parser::BaseParser;
use crate::bash::parser::BashParser;
use crate::c::parser::CParser;
use crate::cpp::parser::CppParser;
use crate::csharp::parser::CSharpParser;
use crate::java::parser::JavaParser;
use crate::lua::parser::LuaParser;
use crate::php::parser::PhpParser;
use crate::python::parser::PythonParser;
use crate::ruby::parser::RubyParser;
use crate::rust::parser::RustParser;
use crate::tokens::replace_tokens;
use crate::typescript::parser::TypescriptParser;

fn replace_indent_placeholders(docblock: &str, use_tabs: bool, indent: usize) -> String {
    let indent_str: String;
    if use_tabs {
        indent_str = "\t".to_string();
    } else {
        indent_str = " ".repeat(indent);
    }
    docblock.replace("<INDENT>", &indent_str)
}

fn postprocess_template(parser_name: &str, template: String, options: &HashMap<&str, bool>) -> String {
    if parser_name == "python" {
        if options["single_quotes"] {
            return template.replace("\"\"\"", "'''");
        }
    }

    template
}

fn postprocess_tokens(
    parser_name: &str,
    tokens: Result<Map<String, Value>, String>,
    options: &HashMap<&str, bool>,
) -> Result<Map<String, Value>, String> {
    let mut new_tokens = tokens.clone().unwrap();

    match parser_name {
        "c" | "cpp" => {
            if options["use_slash_char"] {
                new_tokens.insert("char".to_string(), Value::String("\\".to_string()));
            } else {
                new_tokens.insert("char".to_string(), Value::String("@".to_string()));
            }
        },
        "python" => {
            new_tokens.insert(
                "show_types".to_string(),
                Value::Bool(!options["omit_redundant_param_types"]),
            );
        },
        "typescript" => {
            new_tokens.insert(
                "show_types".to_string(),
                Value::Bool(!options["omit_redundant_param_types"]),
            );

            // Return values might have parenthesis, like `(Foo | Bar)`,
            // but jsdoc simply wants `Foo | Bar`, so let's remove them.
            let return_type = new_tokens.get("return_type");
            let is_async = new_tokens.get("async");
            if return_type.is_some() {
                let mut return_value = return_type.unwrap().as_str().unwrap().to_string();
                if return_value.starts_with("(") && return_value.ends_with(")") {
                    return_value.remove(0);
                    return_value.remove(return_value.len() - 1);
                    return_value = return_value.trim().to_string();
                }

                // If we're dealing with an async function, then the return type
                // with value T, should be wrapped inside a Promise<T>.
                if is_async.is_some() {
                    if !return_value.starts_with("Promise") {
                        return_value = format!("Promise<{}>", return_value);
                    }
                }

                new_tokens.insert("return_type".to_string(), Value::String(return_value));
            } else if is_async.is_some() {
                // If there is no return type, but the function is marked with
                // async, the return type should be Promise<[TODO:type]>.
                new_tokens.insert("return_type".to_string(), Value::String("Promise<[TODO:type]>".to_string()));
            }
        },
        _ => {}
    }

    return Ok(new_tokens);
}

pub fn get_node_types<'a>(node_types_conf: &'a serde_yaml::Value) -> Vec<&'a str> {
    let mut node_types = Vec::new();

    for node_type in node_types_conf.as_sequence().unwrap() {
        node_types.push(node_type.as_str().unwrap());
    }

    node_types
}

pub fn generate(
    parser_name: &str,
    doc_name: &str,
    code: &str,
    line: &usize,
    options: &HashMap<&str, bool>,
    use_tabs: bool,
    indent: usize,
) -> Result<Value, Box<dyn std::error::Error>> {
    let doc_config: serde_yaml::Value = serde_yaml::from_str(load_doc_config_str(parser_name, doc_name))?;

    // Go through each template in the docblock and return the first result of
    // the template that got parsed successfully.
    for (_, conf) in doc_config["templates"].as_mapping().unwrap().iter() {
        let node_types = get_node_types(&conf["node_types"]);

        let parser: Box<dyn BaseParser> = match parser_name {
            "php" => Box::new(PhpParser::new(code, line, &node_types, options)) as Box<dyn BaseParser>,
            "bash" => Box::new(BashParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
            "lua" => Box::new(LuaParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
            "ruby" => Box::new(RubyParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
            "rust" => Box::new(RustParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
            "csharp" => Box::new(CSharpParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
            "java" => Box::new(JavaParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
            "python" => Box::new(PythonParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
            "c" => Box::new(CParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
            "cpp" => Box::new(CppParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
            "typescript" => Box::new(TypescriptParser::new(code, line, &node_types, options)) as Box<dyn BaseParser>,
            _ => panic!("Unsupported parser: {}", &parser_name),
        };

        if let Some(tokens) = parser.parse() {
            let new_line_num = parser.postprocess_line(*line);

            let new_tokens = postprocess_tokens(parser_name, tokens, options);
            let docblock_str = replace_tokens(&conf["template"].as_str().unwrap(), &new_tokens?)?;

            let replaced_docblock_str = replace_indent_placeholders(&docblock_str, use_tabs, indent);
            let final_docblock_str = postprocess_template(parser_name, replaced_docblock_str, options);
            let docblock_lines: Vec<&str> = final_docblock_str.split("\n").collect();

            return Ok(json!({
                "line": new_line_num,
                "docblock": docblock_lines,
            }));
        }
    }

    Ok(Value::Null)
}
