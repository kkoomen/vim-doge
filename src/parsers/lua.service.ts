import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
  FUNCTION = 'function',
  FUNCTION_DEFINITION = 'function_definition',
}

export class LuaParserService
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
        case NodeType.FUNCTION:
        case NodeType.FUNCTION_DEFINITION: {
          this.result = { name: null, parameters: [] };
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
    // prettier-ignore
    if (['local_variable_declaration', 'variable_declaration'].includes(node.parent?.type as string)) {
      const identifierNode = node.parent?.children
        .filter((n: SyntaxNode) => n.type === 'variable_declarator').shift() as SyntaxNode;

      if (identifierNode.childCount > 0 && identifierNode.child(0)?.type === 'field_expression') {
        this.result.name = identifierNode.child(0)?.children.pop()?.text;
      } else {
        this.result.name = identifierNode?.text;
      }
    }

    node.children.forEach((childNode: SyntaxNode) => {
      switch (childNode.type) {
        case 'function_name': {
          this.result.name =
            childNode.childCount > 0
              ? childNode.children.pop()?.text
              : childNode.text;
          break;
        }

        case 'parameters': {
          childNode.children
            .filter((n: SyntaxNode) => n.type === 'identifier')
            .forEach((cn: SyntaxNode) => {
              this.result.parameters.push({ name: cn.text });
            });
          break;
        }

        default:
          break;
      }
    });
  }
}
