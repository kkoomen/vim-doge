import { SyntaxNode } from 'tree-sitter';
import { Language } from '../constants';
import { ValueOf } from '../types';
import { BashParserService } from './bash.service';
import { CParserService } from './c.service';
import { CppParserService } from './cpp.service';
import { JavaParserService } from './java.service';
import { LuaParserService } from './lua.service';
import { PhpParserService } from './php.service';
import { PythonParserService } from './python.service';
import { RubyParserService } from './ruby.service';
import { RustParserService } from './rust.service';
import { TypeScriptParserService } from './typescript.service';

export type ParserService =
  | PhpParserService
  | TypeScriptParserService
  | PythonParserService
  | CParserService
  | CppParserService
  | BashParserService
  | RubyParserService
  | LuaParserService
  | JavaParserService
  | RustParserService;

export function getParserService(
  language: ValueOf<Language>,
  args: [SyntaxNode, number, string[]],
): ParserService | undefined {
  switch (language) {
    case Language.PHP:
      return new PhpParserService(...args);

    case Language.TYPESCRIPT:
      return new TypeScriptParserService(...args);

    case Language.PYTHON:
      return new PythonParserService(...args);

    case Language.C:
      return new CParserService(...args);

    case Language.CPP:
      return new CppParserService(...args);

    case Language.BASH:
      return new BashParserService(...args);

    case Language.RUBY:
      return new RubyParserService(...args);

    case Language.LUA:
      return new LuaParserService(...args);

    case Language.JAVA:
      return new JavaParserService(...args);

    case Language.RUST:
      return new RustParserService(...args);

    default:
      // prettier-ignore
      console.error(`Could not get parser service for unknown language: ${language}`);
      break;
  }
}
