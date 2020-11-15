import fs from 'fs';
import Parser from 'tree-sitter';
import pkg from '../package.json';
import { Language } from './constants';
import { loadParserPackage } from './helpers';
import { getParserService } from './parsers';
import { ValueOf } from './types';

const args: string[] = process.argv.slice(2);

if (args[0] === '--version') {
  console.log(`v${pkg.version}`);
  process.exit(0);
}

const filepath: string = args.shift() as string;
const language: ValueOf<Language> = args.shift() as ValueOf<Language>;
const lineNumber: number = Math.max(0, Number(args.shift()) - 1);
const nodeTypes: string[] = args;

const languageParser = loadParserPackage(language);
if (languageParser) {
  const parser = new Parser();
  parser.setLanguage(languageParser);

  const sourceCode = fs.readFileSync(filepath, { encoding: 'utf8', flag: 'r' });

  const tree = parser.parse(sourceCode);
  const parserService = getParserService(language, [
    tree.rootNode,
    lineNumber,
    nodeTypes,
  ]);
  if (parserService) {
    parserService.traverse(tree.rootNode);
    parserService.output();
  }
} else {
  console.error(`Could not load parser for ${language}`);
}
