import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
  METHOD_DECLARATION = 'method_declaration',
  FUNCTION_DEFINITION = 'function_definition',
  PROPERTY_DECLARATION = 'property_declaration',
}

export class PhpParserService
  extends BaseParserService
  implements CustomParserService {
  constructor(
    private readonly rootNode: SyntaxNode,
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
        case NodeType.PROPERTY_DECLARATION: {
          this.result = { type: null, fqn: null };
          this.runNodeParser(this.parseClassProperty, node);
          break;
        }

        case NodeType.FUNCTION_DEFINITION:
        case NodeType.METHOD_DECLARATION: {
          const methodName = node.children
            .filter((n: SyntaxNode) => n.type === 'name')
            .shift()?.text;

          this.result = {
            visibility: null,
            name: null,
            parameters: [],
            returnType: null,
            isNoConstructorMethod: methodName !== '__construct',
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

  private resolveFQN(type: string): string | null {
    let fqn = null;
    this.rootNode.children
      .filter((n: SyntaxNode) => n.type === 'namespace_use_declaration')
      .forEach((n: SyntaxNode) => {
        n.children
          .filter((cn: SyntaxNode) => cn.type === 'namespace_use_clause')
          .forEach((namespaceNode: SyntaxNode) => {
            const isAlias: boolean =
              namespaceNode.children.filter(
                (cn: SyntaxNode) => cn.type === 'namespace_aliasing_clause',
              ).length > 0;

            if (!isAlias) {
              const fqnNode: SyntaxNode = namespaceNode.children
                .filter((cn: SyntaxNode) => cn.type === 'qualified_name')
                .shift() as SyntaxNode;

              const fqnName: string | undefined = fqnNode.children
                .filter((cn: SyntaxNode) => cn.type === 'name')
                .shift()?.text;

              if (fqnName === type) {
                fqn = this.escapeFQN(`\\${fqnNode.text}`);
              }
            }
          });
      });
    return fqn;
  }

  private getClassPropertyTypeViaConstructor(
    node: SyntaxNode,
  ): string | undefined {
    const propertyName: string | undefined = node?.children
      .filter((n: SyntaxNode) => n.type === 'property_element')
      .shift()
      ?.children.shift()
      ?.children.pop()?.text;

    if (!propertyName) {
      return;
    }

    const constructorNode: SyntaxNode | undefined = node?.parent?.children
      .filter((n: SyntaxNode) => n.type === 'method_declaration')
      .filter((n: SyntaxNode) => {
        const methodName: string | undefined = n.children
          .filter((cn) => cn.type === 'name')
          .shift()?.text;
        return methodName === '__construct';
      })
      .shift();

    if (!constructorNode) {
      return;
    }

    let paramName: string | undefined;
    constructorNode?.children
      .filter((n: SyntaxNode) => n.type === 'compound_statement')
      .shift()
      ?.children.filter((n: SyntaxNode) => n.type === 'expression_statement')
      .forEach((n: SyntaxNode) => {
        const expr: SyntaxNode = n.children
          .filter((cn: SyntaxNode) => cn.type === 'assignment_expression')
          .shift() as SyntaxNode;

        const propName: string | undefined = expr.children
          .filter((cn: SyntaxNode) => cn.type === 'member_access_expression')
          .shift()
          ?.children.pop()?.text;

        if (propName === propertyName) {
          paramName = expr.children
            .filter((cn: SyntaxNode) => cn.type === 'variable_name')
            .shift()?.text;
        }
      });

    if (!paramName) {
      return;
    }

    const paramType: string | undefined = constructorNode?.children
      .filter((n: SyntaxNode) => n.type === 'formal_parameters')
      .shift()
      ?.children.filter((n: SyntaxNode) => n.type === 'simple_parameter')
      .filter((n: SyntaxNode) => {
        const name: string | undefined = n.children
          .filter((cn: SyntaxNode) => cn.type === 'variable_name')
          .shift()?.text;
        return name === paramName;
      })
      .shift()
      ?.children.filter((n: SyntaxNode) =>
        ['optional_type', 'type_name', 'primitive_type'].includes(n.type),
      )
      .shift()?.text;

    return paramType;
  }

  private parseClassProperty(node: SyntaxNode): void {
    const propertyType = this.getClassPropertyTypeViaConstructor(node);
    if (propertyType) {
      this.result.type = this.escapeFQN(propertyType);
      this.result.fqn = this.resolveFQN(propertyType);
    }
  }

  private parseFunction(node: SyntaxNode): void {
    node.children.forEach((childNode: SyntaxNode) => {
      switch (childNode.type) {
        case 'visibility_modifier': {
          this.result.visibility = childNode.text;
          break;
        }

        case 'name': {
          this.result.name = childNode.text;
          break;
        }

        case 'optional_type':
        case 'type_name':
        case 'primitive_type': {
          this.result.returnType = this.escapeFQN(childNode.text);
          this.result.returnTypeFQN = this.resolveFQN(childNode.text);
          break;
        }

        case 'formal_parameters': {
          childNode.children
            .filter((n: SyntaxNode) => n.type === 'simple_parameter')
            .forEach((n: SyntaxNode) => {
              const param: Record<string, any> = {
                name: null,
                type: null,
                default: null,
                fqn: null,
              };
              n.children.forEach((pn: SyntaxNode) => {
                // Param type.
                // prettier-ignore
                if (['primitive_type', 'type_name', 'optional_type'].includes(pn.type)) {
                  param.type = this.escapeFQN(pn.text);
                  param.fqn = this.resolveFQN(pn.text);
                }

                // Param name.
                if (pn.type === 'variable_name') {
                  param.name = pn.text;
                }

                // Default value.
                if (pn.previousSibling?.type === '=') {
                  param.default = pn.text;
                }
              });
              this.result.parameters.push(param);
            });
          break;
        }

        case 'compound_statement': {
          this.parseExceptions(childNode);
          break;
        }

        default:
          break;
      }
    });
  }

  private parseExceptions(node: SyntaxNode) {
    if (node.type === 'throw_statement') {
      const exception: Record<string, any> = { name: null };

      const name = node.children
        .filter((n: SyntaxNode) => n.type === 'object_creation_expression')
        .shift()
        ?.children.filter((n: SyntaxNode) => n.type === 'qualified_name')
        .shift()?.text;
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

  private escapeFQN(fqn: string): string {
    return fqn.replace(/\\/g, '\\\\');
  }
}
