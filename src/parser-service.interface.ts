import { SyntaxNode } from 'tree-sitter';

export interface CustomParserService {
  traverse(node: SyntaxNode): void;
  output(): void;
}
