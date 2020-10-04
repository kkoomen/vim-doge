import { SyntaxNode } from 'tree-sitter';
import { Language } from '../constants';
import { ValueOf } from '../helpers';
import { PhpParserService } from './php.service';
import { PythonParserService } from './python.service';
import { TypeScriptParserService } from './typescript.service';

export type ParserService = PhpParserService
  | TypeScriptParserService
  | PythonParserService

export function getParserService(
  language: ValueOf<Language>,
  args: [SyntaxNode, number, string[]]
): ParserService | undefined {
  switch (language) {
    case Language.PHP:
      return new PhpParserService(...args);

    case Language.TYPESCRIPT:
      return new TypeScriptParserService(...args);

    case Language.PYTHON:
      return new PythonParserService(...args);

    default:
      console.error(`Could not get parser service for unknown language: ${language}`)
      break;
  }
}
