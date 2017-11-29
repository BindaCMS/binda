const path = require('path');
const webpack = require('webpack');

module.exports = {

  entry: __dirname + '/app/assets/javascripts/binda/index.js',

  output: {
    filename: 'binda.bundle.js',
    path: __dirname + '/app/assets/javascripts/binda/dist'
  },

  module: {
    rules: [{
      test: /\.js$/,
      enforce: "pre",
      loader: "jshint-loader",
      options: {
        esversion: 6,
        asi: true,
        failOnHint: true,
        emitErrors: true,
      }
    },
    {
      test: /\.js$/,
      loader: "babel-loader",
      options: {
        presets: [['es2015', {modules: false}]],
        plugins: ['syntax-dynamic-import']
      }
    }]
  },
  
  watch: true,
};