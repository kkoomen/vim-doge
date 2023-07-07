use tera::{Tera, Context};
use regex::Regex;
use serde_json::{Map, json, Value};

pub fn replace_tokens(
    template: &str,
    tokens: &Map<String, Value>,
) -> Result<String, Box<dyn std::error::Error>> {
    let mut tera = Tera::default();

    let tokens_json = json!(tokens);
    let context = Context::from_serialize(tokens_json).unwrap();
    match tera.add_raw_template("docblock", template) {
        Ok(()) => {},
        Err(err) => panic!("Failed to render template: {:#?}", err),
    }

    let docstring = tera.render("docblock", &context).unwrap();
    let docstring_lines: Vec<&str> = docstring.split("\n").collect();

    let clean_docstring: Vec<String> = docstring_lines
        .iter()
        .filter(|line| !line.trim().is_empty())
        .map(|line| {
            let patterns = [
                (r" +", " "),   // Replace multiple spaces with a single space.
                (r"^~$", ""),   // Lines marked with ~ are those to be preserved
            ];

            let mut new_line = line.to_owned().to_string();

            for (pattern, replacement) in patterns.iter() {
                let regex = Regex::new(pattern).unwrap();
                new_line = regex.replace_all(&new_line, *replacement).to_string();
            }

            new_line
        })
        .collect();

    Ok(clean_docstring.join("\n"))
}
