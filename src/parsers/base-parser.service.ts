import { SyntaxNode } from 'tree-sitter';

export class BaseParserService {
  /**
   * The result that will be printed for vim to handle later.
   */
  protected result: Record<string, any> = {};

  /**
   * Whether the parsing process is done or not.
   */
  protected done = false;

  /**
   * Force an empty object to be printed. Can be useful if you want to render a
   * template without any tokens.
   */
  protected forceOutput = false;

  public output(): void {
    if (this.forceOutput) {
      console.log('{}');
    } else if (Object.keys(this.result).length > 0) {
      console.log(JSON.stringify(this.result));
    }
  }

  protected runNodeParser(parser: (node: SyntaxNode) => void, node: SyntaxNode): void {
    this.done = true;
    parser.bind(this)(node);
  }
}
