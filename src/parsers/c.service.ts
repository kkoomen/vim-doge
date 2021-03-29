import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
  FUNCTION_DEFINITION = 'function_definition',
  DECLARATION = 'declaration',
  STRUCT_SPECIFIER = 'struct_specifier',
  FIELD_DECLARATION = 'field_declaration',
}

export class CParserService
  extends BaseParserService
  implements CustomParserService {
  constructor(
    readonly rootNode: SyntaxNode,
    private readonly lineNumber: number,
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
        case NodeType.FUNCTION_DEFINITION:
        case NodeType.DECLARATION: {
          this.result = {
            name: null,
            parameters: [],
            returnType: null,
          };
          this.runNodeParser(this.parseFunction, node);
          break;
        }

        case NodeType.STRUCT_SPECIFIER: {
          this.result = { name: null };
          this.runNodeParser(this.parseStruct, node);
          break;
        }

        case NodeType.FIELD_DECLARATION: {
          this.result = { name: null };
          this.runNodeParser(this.parseFieldDeclaration, node);
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
          this.result.name = childNode.children
            .filter((n: SyntaxNode) => n.type === 'identifier')
            .shift()?.text;

          childNode.children
            .filter((n: SyntaxNode) =>
              ['parameter_list', 'parameter_declaration'].includes(n.type),
            )
            .map((n: SyntaxNode) =>
              n.children.filter(
                (cn: SyntaxNode) => cn.type === 'parameter_declaration',
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

                if (cn.type === 'pointer_declarator') {
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
}
