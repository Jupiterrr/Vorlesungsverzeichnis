var path = require('path');
var webpack = require('webpack');
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: [
    './scripts/index'
  ],
  output: {
    path: path.join(__dirname, 'build'),
    filename: 'bundlex.js',
    publicPath: '/scripts/'
  },
  plugins: [
    new ExtractTextPlugin('main.scss')
  ],
  resolve: {
    extensions: ['', '.js', '.jsx', '.scss']
  },
  module: {
    loaders: [
      { test: /\.scss$/, loader: ExtractTextPlugin.extract("style-loader", "css!sass") },
      {
        test: /\.jsx?$/,
        loaders: ['babel'],
        include: path.join(__dirname, 'scripts')
      }
    ]
  }
};
