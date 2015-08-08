'use strict';

Object.defineProperty(exports, '__esModule', {
  value: true
});

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ('value' in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

var _get = function get(_x, _x2, _x3) { var _again = true; _function: while (_again) { var object = _x, property = _x2, receiver = _x3; desc = parent = getter = undefined; _again = false; if (object === null) object = Function.prototype; var desc = Object.getOwnPropertyDescriptor(object, property); if (desc === undefined) { var parent = Object.getPrototypeOf(object); if (parent === null) { return undefined; } else { _x = parent; _x2 = property; _x3 = receiver; _again = true; continue _function; } } else if ('value' in desc) { return desc.value; } else { var getter = desc.get; if (getter === undefined) { return undefined; } return getter.call(receiver); } } };

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { 'default': obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError('Cannot call a class as a function'); } }

function _inherits(subClass, superClass) { if (typeof superClass !== 'function' && superClass !== null) { throw new TypeError('Super expression must either be null or a function, not ' + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _Week = require('./Week');

var _Week2 = _interopRequireDefault(_Week);

var _layoutday = require('./layoutday');

var _layoutday2 = _interopRequireDefault(_layoutday);

var _lodash = require('lodash');

// require("../styles/main.scss");
// require("../styles/kithub.scss");

var eventsData = require("./kithub-data.js");

// var events = [
//   {start: new Date("11:00 4.2.2015"), end: new Date("12:00 4.2.2015"), title: "test1"},
//   {start: new Date("12:00 4.9.2015"), end: new Date("12:45 4.9.2015"), title: "test2"},
//   {start: new Date("10:00 4.9.2015"), end: new Date("13:00 4.9.2015"), title: "test2"}
// ];

function weekMapper(d) {
  function getMonday(d) {
    var d = new Date(d),
        day = d.getDay(),
        diff = d.getDate() - day + (day == 0 ? -6 : 1); // adjust when day is sunday
    return new Date(d.setDate(diff));
  }
  var monday = getMonday(d);
  return function mapToCurrentWeek(d) {
    var d = new Date(d),
        day = d.getDay(),
        gday = day == 0 ? 6 : day - 1,
        // wday starting with monday
    date = monday.getDate() + gday;
    return new Date(monday.getFullYear(), monday.getMonth(), date, d.getHours(), d.getMinutes(), d.getSeconds());
  };
}

function parseEventData(events) {
  var toCurrentWeek = weekMapper(new Date());
  var parseDate = function parseDate(a) {
    return new Date(a[0], a[1] - 1, a[2], a[3], a[4], a[5]);
  };

  return events.map(function (event) {
    var startTime = parseDate(event.start);
    var endTime = parseDate(event.end);
    var new_event = {
      start: toCurrentWeek(startTime),
      end: toCurrentWeek(endTime),
      title: "<div>" + event.title + "</div>",
      react: _react2['default'].createElement('div', { className: 'body', dangerouslySetInnerHTML: { __html: event.title } }),
      id: event.id,
      url: event.url,
      color: event.color
      // "start_h": startTime.getHours(),
      // "end_h": endTime.getHours()
    };
    return new_event;
  });
}

function sliceWeek(days) {
  var showSat = days[6].events.length > 0;
  days = days.slice(0, showSat ? 7 : 6); // remove saturday
  days = days.slice(1); // remove sunday
  return days;
}

function prepareData(dates) {
  // console.log("data", dates);
  // var groups = groupBy(dates, (e) => {
  //   return e.start + e.end + e._title + e.room + e.id;
  // });
  // console.log("groups", groups);
  // var reducedEvents = values(groups).map((group) => {
  //   var event = group[0];
  //   if (group.length > 1) event.room = "verschiedene Räume";
  //   return event;
  // });
  var myEvents = parseEventData(dates);

  var l = new _layoutday2['default']({ startHour: 7, endHour: 20, height: 800 });
  l.layoutDay(myEvents);
  // window.events = myEvents;
  var days = sliceWeek(l.eventsToWeek(myEvents));
  return days;
}
//eventsToDays(this.props.events);

var App = (function (_React$Component) {
  _inherits(App, _React$Component);

  function App() {
    _classCallCheck(this, App);

    _get(Object.getPrototypeOf(App.prototype), 'constructor', this).apply(this, arguments);
  }

  // React.render(<App />, document.getElementById('root'));

  _createClass(App, [{
    key: 'render',
    value: function render() {
      var days = prepareData(this.props.dates);
      return _react2['default'].createElement(_Week2['default'], { days: days });
    }
  }]);

  return App;
})(_react2['default'].Component);

exports['default'] = App;
module.exports = exports['default'];