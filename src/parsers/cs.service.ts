import { SyntaxNode } from 'tree-sitter';
import { BaseParserService } from './base-parser.service';
import { CustomParserService } from './custom-parser-service.interface';

enum NodeType {
    METHOD_DECLARATION = 'method_declaration',
    CLASS_DECLARATION = 'class_declaration',
    VARIABLE_DECLARATION = 'variable_declaration',
    PROPERTY_DECLARATION = 'property_declaration',
    CONSTRUCTOR_DECLARATION = 'constructor_declaration',
    CONSTANT_DECLARATION = 'field_declaration',
    OPERATOR_DECLARATION = 'operator_declaration',
    DELEGATE_DECLARATION = 'delegate_declaration',
    ENUM_DECLARATION = 'enum_declaration'
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
            case NodeType.DELEGATE_DECLARATION:
            case NodeType.OPERATOR_DECLARATION:
                this.result = { parameters: [], hasReturn: true };
                this.runNodeParser(this.parseFunction, node);
                break;

            case NodeType.CONSTRUCTOR_DECLARATION:
                this.result = { parameters: [] };
                this.runNodeParser(this.parseConstructor, node);
                break;

            case NodeType.VARIABLE_DECLARATION:
            case NodeType.ENUM_DECLARATION:
            case NodeType.CONSTANT_DECLARATION:
            case NodeType.PROPERTY_DECLARATION:
            case NodeType.CLASS_DECLARATION:
                this.result = { exist: true };
                this.runNodeParser(() => {}, node);
                break;


            default: 
                console.error(`Unable to handle node type: ${node.type}`);
                break;
        }
    }

    private parseFunction(node: SyntaxNode): void {
        node.children.forEach((childNode: SyntaxNode) => {
            if (childNode.type == "void_keyword") {
                this.result.hasReturn = false;
            } else if (childNode.type == "parameter_list") {
                this.extractParamsFromList(childNode);
            }
        });
    }

    private parseConstructor(node: SyntaxNode): void {
        node.children.forEach((childNode: SyntaxNode) => {
            if (childNode.type !== "parameter_list") {
                return;
            }

            this.extractParamsFromList(childNode);
        });
    }

    private extractParamsFromList(parameterList: SyntaxNode) {
        parameterList.children.forEach((parameterNode: SyntaxNode) => {
            if (parameterNode.type !== "parameter") {
                return;
            }

            let idCount = 0;
            for (let idNode of parameterNode.children) {
                // let idNode: SyntaxNode = parameterNode.child(i);
                if (idNode.type === "parameter_modifier") {
                    continue;
                }

                idCount++;

                if (0 === idCount % 2) {
                    this.result.parameters.push({ name: idNode.text });
                }
            }
        });
    }
}
