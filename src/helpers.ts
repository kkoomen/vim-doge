import { Language } from './constants';
import { ValueOf } from './types';

export function loadPackage(packageName: string): any {
  try {
    return require(packageName);
  } catch (err) {
    return null;
  }
}

export function loadParserPackage(language: ValueOf<Language>): any {
  const languages: Record<string, string> = {
    [Language.PHP]: 'tree-sitter-php',
    [Language.TYPESCRIPT]: 'tree-sitter-typescript/typescript',
    [Language.PYTHON]: 'tree-sitter-python',
    [Language.C]: 'tree-sitter-c',
    [Language.CPP]: 'tree-sitter-cpp',
    [Language.BASH]: 'tree-sitter-bash',
    [Language.RUBY]: 'tree-sitter-ruby',
    [Language.LUA]: 'tree-sitter-lua',
    [Language.JAVA]: 'tree-sitter-java',
  };

  if (!Object.keys(languages).includes(language as string)) {
    return null;
  }

  return loadPackage(languages[language as string]);
}
