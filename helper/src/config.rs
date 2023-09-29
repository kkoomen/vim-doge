pub fn load_doc_config_str<'a>(parser_name: &'a str, doc_name: &'a str) -> &'a str {
    let config_name = format!("{}_{}", parser_name, doc_name);
    match config_name.as_str() {
        "python_reST" => include_str!("python/docs/reST.yaml"),
        "python_numpy" => include_str!("python/docs/numpy.yaml"),
        "python_google" => include_str!("python/docs/google.yaml"),
        "python_sphinx" => include_str!("python/docs/sphinx.yaml"),

        "cpp_doxygen_cpp_comment_exclamation" => include_str!("cpp/docs/doxygen_cpp_comment_exclamation.yaml"),
        "cpp_doxygen_cpp_comment_slash" => include_str!("cpp/docs/doxygen_cpp_comment_slash.yaml"),
        "cpp_doxygen_cpp_comment_slash_banner" => include_str!("cpp/docs/doxygen_cpp_comment_slash_banner.yaml"),
        "cpp_doxygen_javadoc" => include_str!("cpp/docs/doxygen_javadoc.yaml"),
        "cpp_doxygen_javadoc_banner" => include_str!("cpp/docs/doxygen_javadoc_banner.yaml"),
        "cpp_doxygen_javadoc_no_asterisk" => include_str!("cpp/docs/doxygen_javadoc_no_asterisk.yaml"),
        "cpp_doxygen_qt" => include_str!("cpp/docs/doxygen_qt.yaml"),
        "cpp_doxygen_qt_no_asterisk" => include_str!("cpp/docs/doxygen_qt_no_asterisk.yaml"),

        "c_doxygen_cpp_comment_exclamation" => include_str!("c/docs/doxygen_cpp_comment_exclamation.yaml"),
        "c_doxygen_cpp_comment_slash" => include_str!("c/docs/doxygen_cpp_comment_slash.yaml"),
        "c_doxygen_cpp_comment_slash_banner" => include_str!("c/docs/doxygen_cpp_comment_slash_banner.yaml"),
        "c_doxygen_javadoc" => include_str!("c/docs/doxygen_javadoc.yaml"),
        "c_doxygen_javadoc_banner" => include_str!("c/docs/doxygen_javadoc_banner.yaml"),
        "c_doxygen_javadoc_no_asterisk" => include_str!("c/docs/doxygen_javadoc_no_asterisk.yaml"),
        "c_doxygen_qt" => include_str!("c/docs/doxygen_qt.yaml"),
        "c_doxygen_qt_no_asterisk" => include_str!("c/docs/doxygen_qt_no_asterisk.yaml"),
        "c_kernel_doc" => include_str!("c/docs/kernel_doc.yaml"),

        "php_phpdoc" => include_str!("php/docs/phpdoc.yaml"),
        "typescript_jsdoc" => include_str!("typescript/docs/jsdoc.yaml"),
        "svelte_jsdoc" => include_str!("typescript/docs/jsdoc.yaml"),
        "lua_ldoc" => include_str!("lua/docs/ldoc.yaml"),
        "java_javadoc" => include_str!("java/docs/javadoc.yaml"),
        "ruby_YARD" => include_str!("ruby/docs/YARD.yaml"),
        "csharp_xmldoc" => include_str!("csharp/docs/xmldoc.yaml"),
        "bash_google" => include_str!("bash/docs/google.yaml"),
        "rust_rustdoc" => include_str!("rust/docs/rustdoc.yaml"),
        "r_roxygen2" => include_str!("r/docs/roxygen2.yaml"),
        "scala_scaladoc" => include_str!("scala/docs/scaladoc.yaml"),

        _ => panic!("Unsupported {} doc: {}", parser_name, doc_name),
    }
}
