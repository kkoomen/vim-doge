import { loadPackage } from '../helpers';

const parserLanguages: Record<string, any> = {};

const languages = [
  'php',
  'typescript',
  'python',
  'c',
  'cpp',
  'bash',
  'ruby',
  'lua',
  'java',
];

languages.forEach((language: string) => {
  const pkg = loadPackage(`tree-sitter-${language}`);
  if (pkg) {
    parserLanguages[language] = pkg;
  }
});

export { parserLanguages };
