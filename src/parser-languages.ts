import C from 'tree-sitter-c';
import PHP from 'tree-sitter-php';
import Python from 'tree-sitter-python';
import TypeScript from 'tree-sitter-typescript/typescript';
import { Language } from './constants';

export const parserLanguages = {
  [Language.PHP]: PHP,
  [Language.TYPESCRIPT]: TypeScript,
  [Language.PYTHON]: Python,
  [Language.C]: C,
};
