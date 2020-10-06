import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
  METHOD_DECLARATION = 'method_declaration',
}

export class JavaParserService
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
        case NodeType.METHOD_DECLARATION: {
          this.result = {
            name: null,
            parameters: [],
            returnType: null,
            exceptions: [],
          };
          this.runNodeParser(this.parseFunction, node);
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
        case 'throws': {
          childNode.children
            .filter((n: SyntaxNode) => n.type === 'type_identifier')
            .forEach((cn: SyntaxNode) => {
              this.result.exceptions.push({ name: cn.text });
            });
          break;
        }

        case 'type_identifier':
        case 'void_type':
        case 'floating_point_type':
        case 'array_type':
        case 'boolean_type':
        case 'integral_type':
        case 'generic_type': {
          this.result.returnType = childNode.text;
          break;
        }

        case 'identifier': {
          this.result.name = childNode.text;
          break;
        }

        case 'formal_parameters': {
          childNode.children
            .filter((n: SyntaxNode) =>
              ['formal_parameter', 'spread_parameter'].includes(n.type),
            )
            .forEach((cn: SyntaxNode) => {
              const param: Record<string, any> = { name: null, type: null };

              param.type = cn.children.shift()?.text;
              param.name = cn.children.pop()?.text;

              this.result.parameters.push(param);
            });
          break;
        }

        default:
          break;
      }
    });
  }
}
