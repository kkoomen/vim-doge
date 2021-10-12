import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
    METHOD_DECLARATION = 'method_declaration',
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
        } else {
            console.log(" -- ", node.type);
        }
    }

    private parseFunction(node: SyntaxNode): void {
        let returnDone = false;
        console.log(" ++ ", node);
        node.children.forEach((childNode: SyntaxNode) => {
            console.log(" ++ ", childNode.text, childNode);
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
}
