import PHP from 'tree-sitter-php';
import TypeScript from 'tree-sitter-typescript/typescript';
import { Language } from './constants';

export const parserLanguages = {
  [Language.PHP]: PHP,
  [Language.TYPESCRIPT]: TypeScript,
}
