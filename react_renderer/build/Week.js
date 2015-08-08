'use strict';

Object.defineProperty(exports, '__esModule', {
  value: true
});

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; desc = parent = getter = undefined; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var React = require('react');
var Day = require('./Day');
// require("../styles/main.scss");

"use strict";

var height = 800;
var startHour = 7;
var endHour = 20;
var hours = endHour - startHour;
var hourHeight = height / hours;

var Week = (function (_React$Component) {
  _inherits(Week, _React$Component);

  function Week() {
    _classCallCheck(this, Week);

    _get(Object.getPrototypeOf(Week.prototype), 'constructor', this).apply(this, arguments);
  }

  _createClass(Week, [{
    key: 'render',
    value: function render() {
      var days = this.props.days;
      var reactDays = days.map(function (day) {
        return React.createElement(Day, { title: day.title, events: day.events });
      });
      // var reactHours = [];
      // for (var h=startHour; h<endHour; h++) {
      //   var style = {height: hourHeight};
      //   reactHours.push(
      //     <div className="hour" style={style}>
      //       <span className="hour-label">{h}:00</span>
      //     </div>
      //   );
      // }
      var rows = [];
      var halfHours = (endHour - startHour) * 2;
      for (var i = 0; i < halfHours; i++) {
        var style = { height: hourHeight / 2 };
        var classes = "grid-line";
        if (i % 2 == 0) classes += " hour";
        var hourLable = undefined;
        if (i % 2 == 0) {
          hourLable = React.createElement(
            'span',
            { className: 'hour-label' },
            i / 2 + startHour,
            ':00'
          );
        }
        if (i == 12 || i == 13) classes += " pause";
        rows.push(React.createElement(
          'div',
          { className: classes, style: style },
          hourLable
        ));
      }

      return React.createElement(
        'div',
        { className: 'weekContainer react-timetable' },
        React.createElement(
          'div',
          { className: 'hours' },
          React.createElement('header', null),
          React.createElement(
            'div',
            { className: 'body' },
            rows
          )
        ),
        reactDays
      );
    }
  }]);

  return Week;
})(React.Component);

exports['default'] = Week;
module.exports = exports['default'];