"use strict";

Object.defineProperty(exports, "__esModule", {
    value: true
});

var _createClass = (function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; })();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var _lodash = require('lodash');

var DAYS = ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"];

var Layouter = (function () {
    function Layouter(options) {
        _classCallCheck(this, Layouter);

        this.startHour = options.startHour;
        this.endHour = options.endHour;
        var hours = this.endHour - this.startHour;
        this.hourHeight = options.height / hours;
    }

    _createClass(Layouter, [{
        key: "layoutDay",
        value: function layoutDay(events) {
            var _this = this;

            var sortedEvents = this.sortByStartTime(events);
            sortedEvents.forEach(function (e) {
                e.style = {};
                e.style.top = _this.yPosition(e.start) + 2 + "px";
                e.style.height = _this.eventHeight(e) - 4 + "px";
                e.style.width = "100%";
            });
            var cluster = [];
            var currentCluster = [];
            var lastEnd = 0;
            sortedEvents.forEach(function (event) {
                if (lastEnd < event.start.getTime()) {
                    cluster.push(currentCluster);
                    currentCluster = [];
                }
                lastEnd = Math.max(lastEnd, event.end.getTime());
                currentCluster.push(event);
            });
            cluster.push(currentCluster);
            cluster.forEach(function (events) {
                var singleWidth = 100 / events.length;
                events.forEach(function (e, i) {
                    e.style.left = singleWidth * i + "%";
                    e.style.width = singleWidth + "%";
                });
            });
            return sortedEvents;
        }
    }, {
        key: "intersect",
        value: function intersect(eventA, eventB) {
            var startA = eventA.start.getTime();
            var startB = eventB.start.getTime();
            var endA = eventA.end.getTime();
            var endB = eventB.end.getTime();
            return;
            startA < startB && endA > startB || startA > startB && startA < endB || startA == startB && endA == endB;
        }
    }, {
        key: "sortByDuration",
        value: function sortByDuration(events) {
            return (0, _lodash.sortBy)(events, function (e) {
                return e.end.getTime() - e.start.getTime();
            });
        }
    }, {
        key: "sortByStartTime",
        value: function sortByStartTime(events) {
            return (0, _lodash.sortBy)(events, function (e) {
                return e.start.getTime();
            });
        }
    }, {
        key: "eventsToWeek",
        value: function eventsToWeek(events) {
            var daysMap = (0, _lodash.groupBy)(events, function (event) {
                return event.start.getDay();
            });
            var days = DAYS.map(function (dayName, i) {
                var events = daysMap[i] || [];
                return { title: dayName, events: events };
            });
            return days;
        }
    }, {
        key: "eventHeight",
        value: function eventHeight(event) {
            return this.yPosition(event.end) - this.yPosition(event.start);
        }
    }, {
        key: "yPosition",
        value: function yPosition(date) {
            var hour = date.getHours();
            var min = date.getMinutes();
            var time = hour + min / 60;
            return (time - this.startHour) * this.hourHeight;
        }
    }]);

    return Layouter;
})();

exports["default"] = Layouter;
module.exports = exports["default"];