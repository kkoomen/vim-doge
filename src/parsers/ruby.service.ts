import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
  METHOD = 'method',
  SINGLETON_METHOD = 'singleton_method',
}

export class RubyParserService
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
        case NodeType.SINGLETON_METHOD:
        case NodeType.METHOD: {
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
    node.children.forEach((childNode: SyntaxNode) => {
      switch (childNode.type) {
        case 'method_parameters': {
          childNode.children
            .filter((n: SyntaxNode) =>
              [
                'identifier',
                'optional_parameter',
                'splat_parameter',
                'hash_splat_parameter',
                'block_parameter',
                'keyword_parameter',
              ].includes(n.type),
            )
            .forEach((cn: SyntaxNode) => {
              const param: Record<string, any> = { name: null };

              if (cn.type === 'identifier') {
                param.name = cn.text;
              }

              // prettier-ignore
              if (['optional_parameter', 'keyword_parameter'].includes(cn.type)) {
                param.name = cn.children.shift()?.text;
              }

              // prettier-ignore
              if (['splat_parameter', 'hash_splat_parameter', 'block_parameter'].includes(cn.type)) {
                param.name = cn.children.pop()?.text;
              }

              this.result.parameters.push(param);
            });
          break;
        }

        case 'identifier': {
          this.result.name = childNode.text;
          break;
        }

        default:
          break;
      }
    });
  }
}
