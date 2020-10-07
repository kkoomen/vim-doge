const nodeExternals = require('webpack-node-externals');

console.log("process.env.TRAVIS >>>>", process.env.TRAVIS);

module.exports = {
  entry: './src/index.ts',
  output: {
    filename: 'index.js',
    libraryTarget: 'this',
  },
  target: 'node',
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        loader: 'ts-loader',
        options: {
          transpileOnly: true,
        },
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js'],
  },
  externals: process.env.TRAVIS === 'true' ? [] : [nodeExternals()],
};
