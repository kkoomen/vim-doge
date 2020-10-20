import Bash from 'tree-sitter-bash';
import C from 'tree-sitter-c';
import CPP from 'tree-sitter-cpp';
import Java from 'tree-sitter-java';
import Lua from 'tree-sitter-lua';
import PHP from 'tree-sitter-php';
import Python from 'tree-sitter-python';
import Ruby from 'tree-sitter-ruby';
import TypeScript from 'tree-sitter-typescript/tsx';
import { Language } from './constants';
import { ValueOf } from './types';

export function loadParserPackage(language: ValueOf<Language>): any {
  const languages: Record<string, string> = {
    [Language.PHP]: PHP,
    [Language.TYPESCRIPT]: TypeScript,
    [Language.PYTHON]: Python,
    [Language.C]: C,
    [Language.CPP]: CPP,
    [Language.BASH]: Bash,
    [Language.RUBY]: Ruby,
    [Language.LUA]: Lua,
    [Language.JAVA]: Java,
  };

  if (!Object.keys(languages).includes(language as string)) {
    return null;
  }

  return languages[language as string];
}
