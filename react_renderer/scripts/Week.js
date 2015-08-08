var React = require('react');
var Day = require('./Day');
// require("../styles/main.scss");

"use strict";

var height = 800;
var startHour = 7;
var endHour = 20;
var hours = endHour - startHour;
var hourHeight = height / hours;

export default class Week extends React.Component {
  render() {
    var days = this.props.days;
    var reactDays = days.map((day) => {
      return (<Day title={day.title} events={day.events} />);
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
    var halfHours = (endHour-startHour)*2;
    for (var i=0; i<halfHours; i++) {
      var style = {height: hourHeight/2};
      let classes = "grid-line";
      if (i%2==0) classes += " hour";
      let hourLable;
      if (i%2==0) {
        hourLable = <span className="hour-label">{(i/2)+startHour}:00</span>;
      }
      if (i==12 || i==13) classes += " pause";
      rows.push(
        <div className={classes} style={style}>
          {hourLable}
        </div>
      );
    }

    return (
      <div className="weekContainer react-timetable">
        <div className="hours">
          <header></header>
          <div className="body">{rows}</div>
        </div>
        {reactDays}
      </div>
    );
  }
}
