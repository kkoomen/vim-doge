import { SyntaxNode } from 'tree-sitter';

export class BaseParserService {
  protected result: Record<string, any> = {};

  protected done = false;

  public output(): void {
    if (Object.keys(this.result).length > 0) {
      console.log(JSON.stringify(this.result));
    }
  }

  protected runNodeParser(
    parser: (node: SyntaxNode) => void,
    node: SyntaxNode,
  ): void {
    this.done = true;
    parser.bind(this)(node);
  }
}
