import React from 'react';
import Week from './Week';
import Layouter from './layoutday'
import {groupBy, values} from 'lodash';

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
    diff = d.getDate() - day + (day == 0 ? -6:1); // adjust when day is sunday
    return new Date(d.setDate(diff));
  }
  var monday = getMonday(d);
  return function mapToCurrentWeek(d) {
    var d = new Date(d),
      day = d.getDay(),
     gday = day == 0 ? 6 : day-1, // wday starting with monday
     date = monday.getDate() + gday;
    return new Date(monday.getFullYear(), monday.getMonth(), date, d.getHours(), d.getMinutes(), d.getSeconds());
  };
}

function parseEventData(events) {
  const toCurrentWeek = weekMapper(new Date());
  const parseDate = (a) => new Date(a[0], a[1]-1, a[2], a[3], a[4], a[5]);

  return events.map((event) => {
    const startTime = parseDate(event.start);
    const endTime = parseDate(event.end);
    const new_event = {
      start: toCurrentWeek(startTime),
      end: toCurrentWeek(endTime),
      title: "<div>"+event.title+"</div>",
      react: (<div className="body" dangerouslySetInnerHTML={{__html: event.title}} />),
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
  const showSat = days[6].events.length>0;
  days = days.slice(0, showSat?7:6); // remove saturday
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

  var l = new Layouter({startHour: 7, endHour: 20, height: 800});
  l.layoutDay(myEvents);
  // window.events = myEvents;
  const days = sliceWeek(l.eventsToWeek(myEvents));
  return days;
}
//eventsToDays(this.props.events);

export default class App extends React.Component {
  render() {
    const days = prepareData(this.props.dates);
    return (
      <Week days={days}/>
    );
  }
}


// React.render(<App />, document.getElementById('root'));
