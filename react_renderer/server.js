var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var TimeTable = require('./build/kithub');
var React = require('react');

app.use(bodyParser.json()); // for parsing application/json

app.post('/', function (req, res) {
  // console.log(req.body);
  var component = React.createElement(TimeTable, {dates: req.body})
  var markup = React.renderToStaticMarkup(component);
  res.send(markup);
  res.end();
});

var server = app.listen(3030, function () {
  var host = server.address().address;
  var port = server.address().port;
  // console.log('Example app listening at http://%s:%s', host, port);
});
