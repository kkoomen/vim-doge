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
        if *options.get("single_quotes").unwrap() {
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
            if *options.get("use_slash_char").unwrap() {
                new_tokens.insert("char".to_string(), Value::String("\\".to_string()));
            } else {
                new_tokens.insert("char".to_string(), Value::String("@".to_string()));
            }
        }
        "python" | "typescript" => {
            new_tokens.insert(
                "show_types".to_string(),
                Value::Bool(!options["omit_redundant_param_types"]),
            );
        }
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
            "typescript" => Box::new(TypescriptParser::new(code, line, &node_types)) as Box<dyn BaseParser>,
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
