import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
  FUNCTION_ITEM = 'function_item',
}

export class RustParserService
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
        case NodeType.FUNCTION_ITEM: {
          this.result = {
            name: null,
            parameters: [],
            unsafe: false,
            errors: false,
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
        case 'identifier': {
          this.result.name = childNode.text;
          break;
        }

        case 'function_modifiers': {
          childNode.children.forEach((n: SyntaxNode) => {
            if (n.type === 'unsafe') {
              this.result.unsafe = true;
            }
          });
          break;
        }

        case 'generic_type': {
          const hasResultReturnType = childNode.children
            .filter(
              (n: SyntaxNode) =>
                n.type === 'type_identifier' && n.text === 'Result',
            )
            .shift();
          if (hasResultReturnType) {
            this.result.errors = true;
          }
          break;
        }

        case 'parameters': {
          childNode.children
            .filter((n: SyntaxNode) => n.type === 'parameter')
            .forEach((child: SyntaxNode) => {
              this.result.parameters.push({
                name: child.children
                  .filter((n: SyntaxNode) => n.type === 'identifier')
                  .shift()?.text,
              });
            });
          break;
        }

        default:
          break;
      }
    });
  }
}
