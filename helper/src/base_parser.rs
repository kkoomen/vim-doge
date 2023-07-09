use serde_json::{Map, Value};
use tree_sitter::Node;

pub trait BaseParser {
    fn parse(&self) -> Option<Result<Map<String, Value>, String>>;

    /// Can be used to do some additional post-parsing processing for the line
    /// number. One common use case is that some languages typescript and java
    /// can have decorators on top of the functions, so we want to insert the
    /// docblock above these. Using this function, we can implement aditional
    /// logic that find the top-most decorator and returns that line number.
    fn postprocess_line(&self, line: usize) -> usize {
        line
    }

    fn get_code_bytes(&self) -> &[u8];

    fn get_node_text(&self, node: &Node) -> String {
        node.utf8_text(self.get_code_bytes()).unwrap().to_owned()
    }

    /// Used as a dummy return value that allows to force render the `template`
    /// key inside doc configs that don't have any variables in the template.
    fn empty_parse_result(&self) -> Option<Result<Map<String, Value>, String>> {
        Some(Result::Ok(Map::new()))
    }
}
