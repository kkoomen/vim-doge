import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
  FUNCTION_DEFINITION = 'function_definition',
  MODULE = 'module',
}

export class PythonParserService
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
        case NodeType.FUNCTION_DEFINITION: {
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
        case 'identifier': {
          this.result.name = childNode.text;
          break;
        }

        case 'type': {
          this.result.returnType = childNode.text;
          break;
        }

        case 'parameters': {
          childNode.children
            .filter((n: SyntaxNode) =>
              [
                'default_parameter',
                'typed_parameter',
                'typed_default_parameter',
                'identifier',
              ].includes(n.type),
            )
            .forEach((cn: SyntaxNode, index: number) => {
              // If this is a class method then we don't want to add the first
              // parameter, because that will be the 'self' keyword.
              if (
                node.parent?.parent?.type === 'class_definition' &&
                index === 0
              ) {
                return;
              }

              const param: Record<string, any> = {
                name: null,
                type: null,
                default: null,
              };

              if (cn.type === 'default_parameter') {
                param.name = cn.child(0)?.text;
                param.default = cn.child(2)?.text;
              }

              if (cn.type === 'typed_parameter') {
                cn.children.forEach((pn: SyntaxNode) => {
                  if (pn.type === 'identifier') {
                    param.name = pn.text;
                  }

                  if (
                    ['list_splat_pattern', 'dictionary_splat_pattern'].includes(
                      pn.type,
                    )
                  ) {
                    param.name = pn.children
                      .filter((cpn: SyntaxNode) => cpn.type === 'identifier')
                      .shift()?.text;
                  }

                  if (pn.type === 'type') {
                    param.type = pn.text;
                  }
                });
              }

              if (cn.type === 'typed_default_parameter') {
                param.name = cn.children
                  .filter((pn: SyntaxNode) => pn.type === 'identifier')
                  .shift()?.text;
                param.type = cn.children
                  .filter((pn: SyntaxNode) => pn.type === 'type')
                  .shift()?.text;
                param.default = cn.children
                  .filter((pn: SyntaxNode) => pn.previousSibling?.type === '=')
                  .shift()?.text;
              }

              if (cn.type === 'identifier') {
                param.name = cn.text;
              }

              this.result.parameters.push(param);
            });
          break;
        }

        case 'block': {
          this.parseExceptions(childNode);
          break;
        }

        default:
          break;
      }
    });
  }

  private parseExceptions(node: SyntaxNode): void {
    if (node.type === 'raise_statement') {
      const exception: Record<string, any> = { name: null };

      const name = node.children
        .filter((n: SyntaxNode) => ['expression_list', 'call'].includes(n.type))
        .shift()
        ?.children.shift()?.text;
      if (name) {
        exception.name = name;
      }

      this.result.exceptions.push(exception);
    }

    if (node.childCount > 0) {
      node.children.forEach((childNode: SyntaxNode) => {
        this.parseExceptions(childNode);
      });
    }
  }
}
