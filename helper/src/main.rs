use clap::{Parser, ValueEnum};
use std::{fs, collections::HashMap};

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    // ========================================================================
    // Global options
    // ========================================================================

    /// Path to the file containing the code to be parsed
    #[arg(short='f', long)]
    filepath: String,

    /// Which parser to use in order to parse the code inside `filepath`
    #[arg(long)]
    parser: String,

    /// The documentation standard name
    #[arg(long)]
    doc_name: String,

    /// The line number of where to parse code (used for filtering)
    #[arg(long)]
    line: usize,

    /// The indent level used when docblocks contain additional indents
    #[arg(long, value_enum, default_value="4")]
    indent: Indent,

    /// Whether to use tabs rather than spaces (ignores --indent)
    #[arg(long)]
    use_tabs: bool,

    // ========================================================================
    // PHP
    // ========================================================================

    /// Whether to resolve FQN for param/return types
    #[arg(long)]
    php_resolve_fqn: bool,

    // ========================================================================
    // Python
    // ========================================================================

    /// Whether to use single quotes for the multiline comments delimiters
    #[arg(long)]
    python_single_quotes: bool,

    /// Whether to omit the `{type}` part of parameters and return types when
    /// the type is specified in the function itself
    #[arg(long)]
    python_omit_redundant_param_types: bool,

    // ========================================================================
    // C and C++ doxygen settings
    // ========================================================================

    /// Whether to use '@' or '\' as the token prefix in the docblock
    #[arg(long)]
    doxygen_use_slash_char: bool,

    // ========================================================================
    // Javascript/Typescript settings
    // ========================================================================

    /// Whether to generate `@param` tags for the destructured properties in a
    /// function expression
    #[arg(long)]
    js_destructuring_props: bool,


    /// Whether to omit the `{type}` part of parameters and return types when
    /// the type is known (i.e. typescript)
    #[arg(long)]
    js_omit_redundant_param_types: bool,
}

#[derive(ValueEnum, Clone, Debug)]
pub enum Indent {
    #[clap(name = "2")]
    Two,
    #[clap(name = "4")]
    Four,
    #[clap(name = "8")]
    Eight,
}

fn main() {
    let args = Args::parse();

    let code = fs::read_to_string(args.filepath)
        .unwrap_or_else(|err| panic!("Failed to read filepath: {:?}", err));

    let indent = match args.indent {
        Indent::Two => 2,
        Indent::Four => 4,
        Indent::Eight => 8
    };

    let mut options = HashMap::new();
    match args.parser.as_str() {
        "php" => {
            options.insert("resolve_fqn", args.php_resolve_fqn);
        },
        "python" => {
            options.insert("single_quotes", args.python_single_quotes);
            options.insert("omit_redundant_param_types", args.python_omit_redundant_param_types);
        },
        "c" | "cpp" => {
            options.insert("use_slash_char", args.doxygen_use_slash_char);
        },
        "typescript" => {
            options.insert("destructuring_props", args.js_destructuring_props);
            options.insert("omit_redundant_param_types", args.js_omit_redundant_param_types);
        },
        _ => {},
    }

    let result = vim_doge_helper::docblock::generate(&args.parser, &args.doc_name, &code,
                                                     &args.line, &options, args.use_tabs,
                                                     indent);

    match result {
        Ok(output) => {
            if output != serde_json::Value::Null {
                println!("{:#}", output)
            }
        },
        Err(err) => println!("Error: {}", err),
    }
}
