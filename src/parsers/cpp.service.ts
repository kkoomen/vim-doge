import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
  FUNCTION_DEFINITION = 'function_definition',
  DECLARATION = 'declaration',
  STRUCT_SPECIFIER = 'struct_specifier',
  FIELD_DECLARATION = 'field_declaration',
  CLASS_SPECIFIER = 'class_specifier',
  TEMPLATE_DECLARATION = 'template_declaration',
  FUNCTION_DECLARATOR = 'function_declarator',
}

export class CppParserService
  extends BaseParserService
  implements CustomParserService {
  constructor(
    readonly rootNode: SyntaxNode,
    private lineNumber: number,
    private readonly nodeTypes: string[],
  ) {
    super();
  }

  public traverse(node: SyntaxNode): void {
    if (
      node.startPosition.row === this.lineNumber &&
      this.nodeTypes.includes(node.type) &&
      this.done === false
    ) {
      switch (node.type) {
        case NodeType.TEMPLATE_DECLARATION: {
          const childNode: SyntaxNode = node.children
            .filter(
              (n: SyntaxNode) =>
                n.previousSibling?.type === 'template_parameter_list',
            )
            .shift() as SyntaxNode;
          this.lineNumber = childNode.startPosition.row;
          this.traverse(childNode);
          break;
        }

        case NodeType.FUNCTION_DECLARATOR:
        case NodeType.FUNCTION_DEFINITION:
        case NodeType.DECLARATION: {
          this.result = {
            typeParameters:
              node.parent?.type === 'template_declaration'
                ? this.getTypeParameters(node.parent)
                : [],
            name: null,
            parameters: [],
            returnType: null,
          };
          if (node.type === NodeType.FUNCTION_DECLARATOR) {
            this.runNodeParser(this.parseFunction, node.parent as SyntaxNode);
          } else {
            this.runNodeParser(this.parseFunction, node);
          }
          break;
        }

        case NodeType.STRUCT_SPECIFIER: {
          this.result = {
            typeParameters:
              node.parent?.type === 'template_declaration'
                ? this.getTypeParameters(node.parent)
                : [],
            name: null,
          };
          this.runNodeParser(this.parseStruct, node);
          break;
        }

        case NodeType.FIELD_DECLARATION: {
          this.result = { name: null };
          this.runNodeParser(this.parseFieldDeclaration, node);
          break;
        }

        case NodeType.CLASS_SPECIFIER: {
          this.result = {
            typeParameters:
              node.parent?.type === 'template_declaration'
                ? this.getTypeParameters(node.parent)
                : [],
            name: null,
          };
          this.runNodeParser(this.parseClass, node);
          break;
        }

        default: {
          console.error(`Unable to handle node type: ${node.type}`);
          break;
        }
      }
    } else if (node.childCount > 0) {
      node.children.forEach((childNode: SyntaxNode) => {
        this.traverse(childNode);
      });
    }
  }

  private parseFunction(node: SyntaxNode): void {
    node.children.forEach((childNode: SyntaxNode) => {
      switch (childNode.type) {
        case 'auto':
        case 'primitive_type':
        case 'type_identifier': {
          this.result.returnType = childNode.text;
          break;
        }

        case 'pointer_declarator': {
          this.parseFunction(childNode);
          break;
        }

        case 'function_declarator': {
          // Return type for statement like:
          //   auto Person::getPersonType () -> PersonType
          // prettier-ignore
          if (childNode.children.some((n) => n.type === 'trailing_return_type')) {
            this.result.returnType = childNode.children
              .filter((n: SyntaxNode) => n.type === 'trailing_return_type')
              .shift()
              ?.children.pop()?.text;
          }

          // Method name.
          childNode.children
            .filter((n: SyntaxNode) =>
              ['identifier', 'scoped_identifier', 'field_identifier'].includes(
                n.type,
              ),
            )
            .forEach((n: SyntaxNode) => {
              if (['identifier', 'field_identifier'].includes(n.type)) {
                this.result.name = n.text;
              }

              if (n.type === 'scoped_identifier') {
                this.result.name = n.children.pop()?.text;
              }
            });

          // Parameters.
          childNode.children
            .filter((n: SyntaxNode) =>
              ['parameter_list', 'parameter_declaration'].includes(n.type),
            )
            .map((n: SyntaxNode) =>
              n.children.filter((cn: SyntaxNode) =>
                [
                  'parameter_declaration',
                  'scoped_type_identifier',
                  'optional_parameter_declaration',
                  'variadic_parameter_declaration',
                ].includes(cn.type),
              ),
            )
            .reduce(
              (items: SyntaxNode[], curr: SyntaxNode[]) => [...items, ...curr],
              [],
            )
            .forEach((n: SyntaxNode) => {
              const param: Record<string, any> = { name: null, type: null };

              n.children.forEach((cn: SyntaxNode) => {
                if (['primitive_type', 'type_identifier'].includes(cn.type)) {
                  param.type = cn.text;
                }

                // prettier-ignore
                if (['pointer_declarator', 'reference_declarator', 'variadic_declarator'].includes(cn.type)) {
                  param.name = cn.children
                    .filter((c: SyntaxNode) => c.type === 'identifier')
                    .shift()?.text;
                }

                if (cn.type === 'identifier') {
                  param.name = cn.text;
                }
              });

              this.result.parameters.push(param);
            });
          break;
        }

        default:
          break;
      }
    });
  }

  private parseStruct(node: SyntaxNode): void {
    node.children.forEach((childNode: SyntaxNode) => {
      switch (childNode.type) {
        case 'type_identifier': {
          this.result.name = childNode.text;
          break;
        }

        default:
          break;
      }
    });
  }

  private parseFieldDeclaration(node: SyntaxNode): void {
    node.children.forEach((childNode: SyntaxNode) => {
      switch (childNode.type) {
        case 'field_identifier': {
          this.result.name = childNode.text;
          break;
        }

        default:
          break;
      }
    });
  }

  private parseClass(node: SyntaxNode): void {
    node.children.forEach((childNode: SyntaxNode) => {
      switch (childNode.type) {
        case 'type_identifier': {
          this.result.name = childNode.text;
          break;
        }

        default:
          break;
      }
    });
  }

  private getTypeParameters(
    node: SyntaxNode,
  ): Array<Record<'name', null | string>> {
    const typeparams: Array<Record<'name', null | string>> = [];

    node.children
      .filter((n: SyntaxNode) => ['template_parameter_list'].includes(n.type))
      .map((n: SyntaxNode) =>
        n.children.filter((cn: SyntaxNode) =>
          [
            'type_parameter_declaration',
            'parameter_declaration',
            'variadic_type_parameter_declaration',
          ].includes(cn.type),
        ),
      )
      .reduce(
        (items: SyntaxNode[], curr: SyntaxNode[]) => [...items, ...curr],
        [],
      )
      .forEach((n: SyntaxNode) => {
        const param: Record<string, any> = { name: null };

        const name = n.children
          .filter((cn) => ['type_identifier', 'identifier'].includes(cn.type))
          .shift()?.text;
        param.name = name;

        typeparams.push(param);
      });

    return typeparams;
  }
}
