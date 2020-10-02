const fs = require('fs');
const Parser = require('tree-sitter');
const PHP = require('tree-sitter-php');

const NodeType = {
  METHOD_DECLARATION: 'method_declaration',
  FUNCTION_DEFINITION: 'function_definition',
  PROPERTY_DECLARATION: 'property_declaration',
}

const parser = new Parser();
parser.setLanguage(PHP);

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
  if (node.childCount === 0) return;
  parser(node, result);
  console.log(JSON.stringify(result));
  done = true;
}

function traverse(node, lineNumber) {
  if (node.startPosition.row === lineNumber && nodeTypes.includes(node.type) && done === false) {
    switch (node.type) {
      case NodeType.PROPERTY_DECLARATION: {
        const result = { type: null, fqn: null };
        parserHandler(parseClassProperty, node, result);
        break;
      }

      case NodeType.FUNCTION_DEFINITION:
      case NodeType.METHOD_DECLARATION: {
        const result = {
          visibility: null,
          name: null,
          parameters: [],
          returnType: null,
          isNoConstructorMethod: node.children.filter((n) => n.type === 'name').shift().text !== '__construct',
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

function resolveFQN(type) {
  let fqn = type;
  tree.rootNode.children.filter((n) => n.type === 'namespace_use_declaration').forEach((n) => {
    n.children.filter((cn) => cn.type === 'namespace_use_clause').forEach((namespaceNode) => {
      const isAlias = namespaceNode.children.filter((cn) => cn.type === 'namespace_aliasing_clause').length > 0
      if (!isAlias) {
        const fqnNode = namespaceNode.children.filter((cn) => cn.type === 'qualified_name').shift();
        const fqnName = fqnNode.children.filter((cn) => cn.type === 'name').shift().text;
        if (fqnName === fqn) {
          fqn = `\\${fqnNode.text}`;
        }
      }
    });
  });
  return fqn;
}

function getClassPropertyTypeViaConstructor(node) {
  const propertyName = node
    .children
    .filter((n) => n.type === 'property_element')
    .shift()
    .children
    .shift()
    .children
    .pop()
    .text;

  const constructorNode = node
    .parent
    .children
    .filter((n) => n.type === 'method_declaration')
    .filter((n) => {
      const methodName = n.children.filter((cn) => cn.type === 'name').shift().text;
      return methodName === '__construct';
    })
    .shift()

  if (!constructorNode) {
    return;
  }

  let paramName = null;
  constructorNode
    .children
    .filter((n) => n.type === 'compound_statement')
    .shift()
    .children
    .filter((n) => n.type === 'expression_statement')
    .forEach((n) => {
      const expr = n.children.filter((cn) => cn.type === 'assignment_expression').shift();
      const propName = expr.children.filter((cn) => cn.type === 'member_access_expression').shift().children.pop().text;
      if (propName === propertyName) {
        paramName = expr.children.filter((cn) => cn.type === 'variable_name').shift().text;
      }
    });

  if (!paramName) {
    return;
  }

  const paramType = constructorNode
    .children
    .filter((n) => n.type === 'formal_parameters')
    .shift()
    .children
    .filter((n) => n.type === 'simple_parameter')
    .filter((n) => {
      const name = n.children.filter((cn) => cn.type === 'variable_name').shift().text;
      return name === paramName;
    })
    .shift()
    .children
    .filter((n) => ['optional_type', 'type_name', 'primitive_type'].includes(n.type))
    .shift()
    .text;
  return paramType;
}

function parseClassProperty(node, result) {
  const propertyType = getClassPropertyTypeViaConstructor(node);
  if (propertyType) {
    result.type = propertyType;
    result.fqn = resolveFQN(propertyType);
  }
}

function parseFunction(node, result) {
  node.children.forEach((childNode) => {
    switch (childNode.type) {
      case 'visibility_modifier': {
        result.visibility = childNode.text;
        break;
      }
      case 'name': {
        result.name = childNode.text;
        break;
      }
      case 'optional_type':
      case 'type_name':
      case 'primitive_type': {
        result.returnType = childNode.text;
        result.returnTypeFQN = resolveFQN(childNode.text);
        break;
      }
      case 'formal_parameters': {
        childNode.children
          .filter((n) => n.type === 'simple_parameter')
          .forEach((n) => {
            const param = { name: null, type: null, default: null };
            n.children.forEach((pn) => {

              // Param type
              if (['primitive_type', 'type_name', 'optional_type'].includes(pn.type)) {
                param.type = pn.text;
                param.fqn = resolveFQN(pn.text);
              }

              // Param name
              if (pn.type === 'variable_name') {
                param.name = pn.text;
              }

              // Default value
              if (pn.previousSibling && pn.previousSibling.type === '=') {
                param.default = pn.text;
              }
            })
          result.parameters.push(param);
        });
        break;
      }
    }
  });
}
