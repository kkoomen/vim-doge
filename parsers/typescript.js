const fs = require('fs');
const Parser = require('tree-sitter');
const TypeScript = require('tree-sitter-typescript/typescript');

const NodeType = {
  ARROW_FUNCTION: 'arrow_function',
  FUNCTION: 'function',
  FUNCTION_DECLARATION: 'function_declaration',
  FUNCTION_SIGNATURE: 'function_signature',
  METHOD_DEFINITION: 'method_definition',
  GENERATOR_FUNCTION_DECLARATION: 'generator_function_declaration',
  GENERATOR_FUNCTION: 'generator_function',
  CLASS_DECLARATION: 'class_declaration',
  CLASS: 'class',
  MEMBER_EXPRESSION: 'member_expression',
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

function parserHandler(parser, node, result) {
  parser(node, result);
  console.log(JSON.stringify(result));
  done = true;
}

function traverse(node, lineNumber) {
  if (node.startPosition.row === lineNumber && nodeTypes.includes(node.type) && done === false) {
    switch (node.type) {
      case NodeType.MEMBER_EXPRESSION: {
        const result = {
          functionName: null,
          propertyName: null,
          generator: false,
          async: false,
          typeParameters: [],
          parameters: [],
          returnType: null,
        };
        const prototypeIdentifier = node.child(0).children.pop();
        if (prototypeIdentifier && prototypeIdentifier.text === 'prototype') {
          parserHandler(parsePrototypeFunction, node, result);
        }
        break;
      }

      case NodeType.CLASS:
      case NodeType.CLASS_DECLARATION: {
        const result = {
          name: null,
          typeParameters: [],
          parentName: null,
          interfaceName: null,
        };
        parserHandler(parseClass, node, result);
        break;
      }

      case NodeType.ARROW_FUNCTION:
      case NodeType.FUNCTION:
      case NodeType.FUNCTION_DECLARATION:
      case NodeType.FUNCTION_SIGNATURE:
      case NodeType.METHOD_DEFINITION:
      case NodeType.GENERATOR_FUNCTION:
      case NodeType.GENERATOR_FUNCTION_DECLARATION: {
        const result = {
          visibility: null,
          static: false,
          generator: false,
          async: false,
          name: null,
          typeParameters: [],
          parameters: [],
          returnType: null,
        };
        parserHandler(parseFunction, node, result);
        break;
      }

      default: {
        console.error(`Unable to handle node type: ${node.type}`)
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
            const typeparam = { name: null, default: null };

            cn.children.forEach((tpn) => {
              if (tpn.type === 'type_identifier') {
                typeparam.name = tpn.text;
              }

              if (tpn.type === 'default_type') {
                typeparam.default = tpn.children.pop().text;
              }
            })

            result.typeParameters.push(typeparam);
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
                  .filter((n) => ['type_identifier', 'nested_type_identifier'].includes(n.type))
                    .shift()
                    .text;
                }

                if (['type_identifier', 'nested_type_identifier'].includes(cn.type)) {
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

function parsePrototypeFunction(node, result) {
  if (node.childCount === 0) return;

  node.children.forEach(((childNode) => {
    switch (childNode.type) {
      case 'member_expression': {
        result.functionName = childNode.child(0).text;
        break;
      }
      case 'property_identifier': {
        result.propertyName = childNode.text;
        break;
      }
    }
  }));

  const funcNode = node.parent.children.pop();
  if (funcNode) {
    parseFunction(funcNode, result);
  }
}

function parseFunction(node, result) {
  if (node.childCount === 0) return;
  let isSingleParamArrowFunc = false;

  if ([NodeType.GENERATOR_FUNCTION_DECLARATION, NodeType.GENERATOR_FUNCTION].includes(node.type)) {
    result.generator = true;
  }

  if (['arrow_function', 'function'].includes(node.type) && node.parent.type === 'variable_declarator') {
    // handle scenario: const foo = (bar) => bar;
    result.name = node.parent.child(0).text;

    if (node.child(0).type === 'identifier') {
      // handle scenario: const foo = bar => bar;
      result.parameters.push({ name: node.child(0).text, type: null, default: null });
      isSingleParamArrowFunc = true;
    }
  }

  node.children.forEach((childNode) => {
    switch (childNode.type) {
      case 'property_identifier':
      case 'identifier': {
        if (childNode.parent.parent.type !== 'variable_declarator') {
          result.name = childNode.text;
        }
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
            const typeparam = { name: null, default: null };

            cn.children.forEach((tpn) => {
              if (tpn.type === 'type_identifier') {
                typeparam.name = tpn.text;
              }

              if (tpn.type === 'default_type') {
                typeparam.default = tpn.children.pop().text;
              }
            })

            result.typeParameters.push(typeparam);
          });
        break;
      }
      case 'type_annotation': {
        result.returnType = childNode.children.filter((n) => n.type !== ':').shift().text;
        break;
      }
      case 'formal_parameters': {
        if (!isSingleParamArrowFunc) {
          childNode
            .children
            .filter((cn) => ['required_parameter', 'rest_parameter', 'optional_parameter'].includes(cn.type))
            .forEach((cn) => {
              const param = {
                name: null,
                type: null,
                default: null,
                optional: cn.type === 'optional_parameter',
              };

              cn.children.forEach((pn) => {
                if (pn.type === 'identifier') {
                  param.name = pn.text;
                }

                if (pn.type === 'type_annotation') {
                  param.type = pn.children.filter((tc) => tc.type !== ':').shift().text;
                }

                if (pn.previousSibling && pn.previousSibling.type === '=') {
                  param.default = pn.text;
                  param.optional = true;
                }
              });

              result.parameters.push(param);
            });
        }
        break;
      }
    }
  });
}
