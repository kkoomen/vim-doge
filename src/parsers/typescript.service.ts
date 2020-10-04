import { SyntaxNode } from 'tree-sitter';
import { CustomParserService } from '../parser-service.interface';
import { BaseParserService } from './base-parser.service';

enum NodeType {
  ARROW_FUNCTION = 'arrow_function',
  FUNCTION = 'function',
  FUNCTION_DECLARATION = 'function_declaration',
  FUNCTION_SIGNATURE = 'function_signature',
  METHOD_DEFINITION = 'method_definition',
  GENERATOR_FUNCTION_DECLARATION = 'generator_function_declaration',
  GENERATOR_FUNCTION = 'generator_function',
  CLASS_DECLARATION = 'class_declaration',
  CLASS = 'class',
  MEMBER_EXPRESSION = 'member_expression',
}

export class TypeScriptParserService extends BaseParserService implements CustomParserService {
  constructor(
    private readonly rootNode: SyntaxNode,
    private readonly lineNumber: number,
    private readonly nodeTypes: string[],
  ) {
    super();
  }

  public traverse(node: SyntaxNode): void {
    if (node.startPosition.row === this.lineNumber && this.nodeTypes.includes(node.type) && this.done === false) {
      switch (node.type) {
        case NodeType.MEMBER_EXPRESSION: {
          this.result = {
            functionName: null,
            propertyName: null,
            generator: false,
            async: false,
            typeParameters: [],
            parameters: [],
            returnType: null,
          };
          const prototypeIdentifier = node.child(0)?.children.pop();
          if (prototypeIdentifier && prototypeIdentifier.text === 'prototype') {
            this.runNodeParser(this.parsePrototypeFunction, node);
          }
          break;
        }

        case NodeType.CLASS:
        case NodeType.CLASS_DECLARATION: {
          this.result = {
            name: null,
            typeParameters: [],
            parentName: null,
            interfaceName: null,
          };
          this.runNodeParser(this.parseClass, node);
          break;
        }

        case NodeType.ARROW_FUNCTION:
        case NodeType.FUNCTION:
        case NodeType.FUNCTION_DECLARATION:
        case NodeType.FUNCTION_SIGNATURE:
        case NodeType.METHOD_DEFINITION:
        case NodeType.GENERATOR_FUNCTION:
        case NodeType.GENERATOR_FUNCTION_DECLARATION: {
          this.result = {
            visibility: null,
            static: false,
            generator: false,
            async: false,
            name: null,
            typeParameters: [],
            parameters: [],
            returnType: null,
          };
          this.runNodeParser(this.parseFunction, node);
          break;
        }

        default: {
          console.error(`Unable to handle node type: ${node.type}`)
          break;
        }
      }
    } else {
      if (node.childCount > 0) {
        node.children.forEach((childNode: SyntaxNode) => {
          this.traverse(childNode);
        });
      }
    }
  }

  private parseClass(node: SyntaxNode): void {
    node.children.forEach((childNode: SyntaxNode) => {
      switch(childNode.type) {
        case 'type_identifier': {
          this.result.name = childNode.text;
          break;
        }
        case 'type_parameters': {
          childNode
            .children
            .filter((n: SyntaxNode) => n.type === 'type_parameter')
            .forEach((cn: SyntaxNode) => {
              const typeparam: Record<string, any> = { name: null, default: null };

              cn.children.forEach((tpn: SyntaxNode) => {
                if (tpn.type === 'type_identifier') {
                  typeparam.name = tpn.text;
                }

                if (tpn.type === 'default_type') {
                  typeparam.default = tpn.children.pop()?.text;
                }
              })

              this.result.typeParameters.push(typeparam);
            });
          break;
        }
        case 'class_heritage': {
          childNode.children.forEach((cn: SyntaxNode) => {
            if (cn.type === 'extends_clause') {
              cn
                .children
                .forEach((cn: SyntaxNode) => {
                  if (cn.type === 'generic_type') {
                    this.result.parentName = cn
                      ?.children
                      .filter((n: SyntaxNode) => ['type_identifier', 'nested_type_identifier'].includes(n.type))
                      .shift()
                      ?.text;
                  }

                  if (['type_identifier', 'nested_type_identifier'].includes(cn.type)) {
                    this.result.parentName = cn.text
                  }
                });
            }

            if (cn.type === 'implements_clause') {
              cn
                .children
                .forEach((cn: SyntaxNode) => {
                  if (cn.type === 'generic_type') {
                    this.result.interfaceName = cn
                      ?.children
                      .filter((n) => n.type === 'type_identifier')
                      .shift()
                      ?.text;
                  }

                  if (cn.type === 'type_identifier') {
                    this.result.interfaceName = cn.text
                  }
                });
            }
          })
          break;
        }
      }
    });
  }

  private parsePrototypeFunction(node: SyntaxNode): void {
    node.children.forEach(((childNode: SyntaxNode) => {
      switch (childNode.type) {
        case 'member_expression': {
          this.result.functionName = childNode.child(0)?.text;
          break;
        }
        case 'property_identifier': {
          this.result.propertyName = childNode.text;
          break;
        }
      }
    }));

    const funcNode = node?.parent?.children.pop();
    if (funcNode) {
      this.parseFunction(funcNode);
    }
  }

  private parseFunction(node: SyntaxNode): void {
    let isSingleParamArrowFunc = false;

    if ([NodeType.GENERATOR_FUNCTION_DECLARATION, NodeType.GENERATOR_FUNCTION].includes(node.type as NodeType)) {
      this.result.generator = true;
    }

    if (['arrow_function', 'function'].includes(node.type) && node.parent?.type === 'variable_declarator') {
      // handle scenario: const foo = (bar) => bar;
      this.result.name = node.parent?.child(0)?.text;

      if (node.child(0)?.type === 'identifier') {
        // handle scenario: const foo = bar => bar;
        this.result.parameters.push({ name: node?.child(0)?.text, type: null, default: null, optional: false });
        isSingleParamArrowFunc = true;
      }
    }

    node.children.forEach((childNode: SyntaxNode) => {
      switch (childNode.type) {
        case 'property_identifier':
        case 'identifier': {
          if (childNode?.parent?.parent?.type !== 'variable_declarator') {
            this.result.name = childNode.text;
          }
          break;
        }
        case 'accessibility_modifier': {
          this.result.visibility = childNode.text;
          break;
        }
        case 'async': {
          this.result.async = true;
          break;
        }
        case 'static': {
          this.result.static = true;
        }
        case 'type_parameters': {
          childNode
            .children
            .filter((n: SyntaxNode) => n.type === 'type_parameter')
            .forEach((cn: SyntaxNode) => {
              const typeparam: Record<string, any> = { name: null, default: null };

              cn.children.forEach((tpn: SyntaxNode) => {
                if (tpn.type === 'type_identifier') {
                  typeparam.name = tpn.text;
                }

                if (tpn.type === 'default_type') {
                  typeparam.default = tpn.children.pop()?.text;
                }
              })

              this.result.typeParameters.push(typeparam);
            });
          break;
        }
        case 'type_annotation': {
          this.result.returnType = childNode.children.filter((n) => n.type !== ':').shift()?.text;
          break;
        }
        case 'formal_parameters': {
          if (!isSingleParamArrowFunc) {
            childNode
              .children
              .filter((cn: SyntaxNode) => ['required_parameter', 'rest_parameter', 'optional_parameter'].includes(cn.type))
              .forEach((cn: SyntaxNode) => {
                const param: Record<string, any> = {
                  name: null,
                  type: null,
                  default: null,
                  optional: cn.type === 'optional_parameter',
                };

                cn.children.forEach((pn: SyntaxNode) => {
                  if (pn.type === 'identifier') {
                    param.name = pn.text;
                  }

                  if (pn.type === 'type_annotation') {
                    param.type = pn.children.filter((tc: SyntaxNode) => tc.type !== ':').shift()?.text;
                  }

                  if (pn.previousSibling?.type === '=') {
                    param.default = pn.text;
                    param.optional = true;
                  }
                });

                this.result.parameters.push(param);
              });
          }
          break;
        }
      }
    });
  }
}
