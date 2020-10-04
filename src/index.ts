import fs from 'fs';
import Parser from 'tree-sitter';
import { Language } from './constants';
import { ValueOf } from './helpers';
import { parserLanguages } from './parser-languages';
import { getParserService } from './parsers';

const args: string[] = process.argv.slice(2);
const filepath: string = args.shift() as string;
const language: ValueOf<Language> = args.shift() as ValueOf<Language>;
const lineNumber: number = Math.max(0, Number(args.shift()) - 1);
const nodeTypes: string[] = args;

const parser = new Parser();
parser.setLanguage(parserLanguages[language as Language]);

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
