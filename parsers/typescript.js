const fs = require('fs');
const Parser = require('tree-sitter');
const TypeScript = require('tree-sitter-typescript/typescript');

const NodeType = {
  ARROW_FUNCTION: 'arrow_function',
  FUNCTION: 'function',
  FUNCTION_DECLARATION: 'function_declaration',
  METHOD_DEFINITION: 'method_definition',
  GENERATOR_FUNCTION_DECLARATION: 'generator_function_declaration',
  CLASS_DECLARATION: 'class_declaration',
}

const parser = new Parser();
parser.setLanguage(TypeScript);

const args = process.argv.slice(2);
const filepath = args[0];
const lineNumber = Number(args[1]) - 1;
const nodeTypes = args.slice(2);

const sourceCode = fs.readFileSync(filepath, { encoding: 'utf8', flag: 'r' });
const tree = parser.parse(sourceCode);
let done = false;

traverse(tree.rootNode, lineNumber);

// =============================================================================
// METHODS
// =============================================================================

function traverse(node, lineNumber) {
  if (node.startPosition.row === lineNumber && nodeTypes.includes(node.type) && done === false) {
    switch (node.type) {
      case NodeType.ARROW_FUNCTION:
      case NodeType.FUNCTION:
      case NodeType.FUNCTION_DECLARATION:
      case NodeType.METHOD_DEFINITION:
      case NodeType.GENERATOR_FUNCTION_DECLARATION: {
        var result = {
          visibility: null,
          static: false,
          generator: false,
          async: false,
          name: null,
          type_parameters: [],
          parameters: [],
          return_type: null,
        };
        parseFunction(node, result);
        done = true;
        console.log(JSON.stringify(result));
        break;
      }

      case NodeType.CLASS_DECLARATION: {
        var result = {
          name: null,
          type_parameters: [],
          parentName: null,
          interfaceName: null,
        };
        parseClass(node, result);
        done = true;
        console.log(JSON.stringify(result));
        break;
      }
    }
  } else {
    if (node.childCount > 0) {
      node.children.forEach((childNode) => {
        traverse(childNode, lineNumber);
      });
    }
  }
}

function parseClass(node, result) {
  if (node.childCount === 0) return;

  node.children.forEach((childNode) => {
    switch(childNode.type) {
      case 'type_identifier': {
        result.name = childNode.text;
        break;
      }
      case 'type_parameters': {
        childNode
          .children
          .filter((n) => n.type === 'type_parameter')
          .forEach((cn) => {
            var typeparam = {};

            cn.children.forEach((tpn) => {
              if (tpn.type === 'type_identifier') {
                typeparam.name = tpn.text;
              }

              if (tpn.type === 'default_type') {
                typeparam.default = tpn.children.pop().text;
              }
            })

            if (Object.keys(typeparam).length > 0) {
              result.type_parameters.push(typeparam);
            }
          });
        break;
      }
      case 'class_heritage': {
        childNode.children.forEach((cn) => {
          if (cn.type === 'extends_clause') {
            cn
              .children
              .forEach((cn) => {
                if (cn.type === 'generic_type') {
                  result.parentName = cn
                    .children
                    .filter((n) => n.type === 'type_identifier')
                    .shift()
                    .text;
                }

                if (cn.type === 'type_identifier') {
                  result.parentName = cn.text
                }
              });
          }

          if (cn.type === 'implements_clause') {
            cn
              .children
              .forEach((cn) => {
                if (cn.type === 'generic_type') {
                  result.interfaceName = cn
                    .children
                    .filter((n) => n.type === 'type_identifier')
                    .shift()
                    .text;
                }

                if (cn.type === 'type_identifier') {
                  result.interfaceName = cn.text
                }
              });
          }
        })
        break;
      }
    }
  });
}

function parseFunction(node, result) {
  if (node.childCount === 0) return;

  if (node.type === 'arrow_function' && node.parent.type === 'variable_declarator') {
    result.name = node.parent.child(0).text;
  }

  node.children.forEach((childNode) => {
    switch (childNode.type) {
      case 'property_identifier':
      case 'identifier': {
        result.name = childNode.text;
        break;
      }
      case 'accessibility_modifier': {
        result.visibility = childNode.text;
        break;
      }
      case 'async': {
        result.async = true;
        break;
      }
      case 'static': {
        result.static = true;
      }
      case 'type_parameters': {
        childNode
          .children
          .filter((n) => n.type === 'type_parameter')
          .forEach((cn) => {
            var typeparam = { type: null, name: null, default: null };

            cn.children.forEach((tpn) => {
              if (tpn.type === 'type_identifier') {
                typeparam.name = tpn.text;
              }

              if (tpn.type === 'default_type') {
                typeparam.default = tpn.children.pop().text;
              }
            })

            if (Object.keys(typeparam).length > 0) {
              result.type_parameters.push(typeparam);
            }
          });
        break;
      }
      case 'type_annotation': {
        result.return_type = childNode.children.filter((n) => n.type !== ':').shift().text;
        break;
      }
      case 'formal_parameters': {
        childNode
          .children
          .filter((cn) => ['required_parameter', 'rest_parameter'].includes(cn.type))
          .forEach((cn) => {
            const param = { type: null, name: null, default: null };

            cn.children.forEach((pn) => {
              if (pn.type === 'object_pattern') {
                pn
                  .children
                  .filter((spn) => ['pair', 'shorthand_property_identifier'].includes(spn.type))
                  .forEach((spn) => {
                    if (!param.props) {
                      param.props = [];
                    }

                    const subparam = {};

                    if (spn.type === 'shorthand_property_identifier') {
                      subparam.name = spn.text;
                    }

                    if (spn.type === 'pair') {
                      subparam.name = spn.children.shift().text;
                      const paramTypeChild = spn.children.pop();
                      if (paramTypeChild.type === 'assignment_expression') {
                        subparam.type = paramTypeChild.children.shift().text;
                        subparam.default = paramTypeChild.children.pop().text;
                      } else {
                        subparam.type = paramTypeChild.text;
                      }
                    }

                    if (Object.keys(subparam).length > 0) {
                      param.props.push(subparam);
                    }
                  });
              }

              if (pn.type === 'identifier') {
                param.name = pn.text;
              }

              if (pn.type === 'type_annotation') {
                param.type = pn.children.filter((tc) => tc.type !== ':').shift().text;
              }

              if (pn.previousSibling?.type === '=') {
                param.default = pn.text;
              }
            });

            if (Object.keys(param).length > 0) {
              result.parameters.push(param);
            }
          });
        break;
      }
    }
  });
}
