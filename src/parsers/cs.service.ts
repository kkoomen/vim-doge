import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
    METHOD_DECLARATION = 'method_declaration',
    CLASS_DECLARATION = 'class_declaration',
    VARIABLE_DECLARATION = 'variable_declaration',
    PROPERTY_DECLARATION = 'property_declaration',
    CONSTRUCTOR_DECLARATION = 'constructor_declaration',
    OPERATOR_DECLARATION = 'operator_declaration',
    CONSTANT_DECLARATION = 'field_declaration'
}

export class CSharpParserService
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
            node.startPosition.row !== this.lineNumber 
            || !this.nodeTypes.includes(node.type) 
            || this.done !== false
        ) {
            if (node.childCount > 0) {
                node.children.forEach((childNode: SyntaxNode) => {
                    this.traverse(childNode);
                });
            }

            return;
        } 

        switch (node.type) {
            case NodeType.METHOD_DECLARATION:
                this.result = { parameters: [], hasReturn: null };
                this.runNodeParser(this.parseFunction, node);
                break;

            case NodeType.CONSTRUCTOR_DECLARATION:
                this.result = { parameters: [] };
                this.runNodeParser(this.parseConstructor, node);
                break;

            default: 
                console.error(`Unable to handle node type: ${node.type}`);
                break;
        }
    }

    private parseFunction(node: SyntaxNode): void {
        let returnDone = false;
        node.children.forEach((childNode: SyntaxNode) => {
            switch (childNode.type) {
                case 'generic_name':
                case 'predefined_type': {
                    this.result.returnType = childNode.text;
                    returnDone = true;
                    break;
                }

                case 'identifier': {
                    if (returnDone) {
                        this.result.name = childNode.text;
                    } else {
                        this.result.returnType = childNode.text;
                        returnDone = true;
                    }
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

    private parseConstructor(node: SyntaxNode): void {
        node.children.forEach((childNode: SyntaxNode) => {
            if (childNode.type !== "parameter_list") {
                return;
            }

            childNode.children.forEach((parameterNode: SyntaxNode) => {
                if (parameterNode.type !== "parameter") {
                    return;
                }

                parameterNode.children.forEach((idNode: SyntaxNode) => {
                    if (idNode.type != "identifier") {
                        return;
                    }

                    this.result.parameters.push({ name: idNode.text });
                });
            });
        });
    }
}
