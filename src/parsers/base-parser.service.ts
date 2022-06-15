import { SyntaxNode } from 'tree-sitter';

export class BaseParserService {
  private defaultResult: Record<string, any> = {};

  protected result: Record<string, any> = {};

  protected done = false;

  public setDefaultResult(result: Record<string, any>) {
    this.defaultResult = result;
  }

  public output(): void {
    if (Object.keys(this.result).length > 0) {
      console.log(JSON.stringify({
        ...this.defaultResult,
        ...this.result
      }));
    }
  }

  protected runNodeParser(parser: (node: SyntaxNode) => void, node: SyntaxNode): void {
    this.done = true;
    parser.bind(this)(node);
  }
}
