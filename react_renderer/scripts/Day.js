import React from 'react';

function time(date) {
  return date.toLocaleTimeString("de").split(":").slice(0,2).join(":");
}

function toReactEvent(event) {
  // event.style.backgroundColor = event.color;
  return (
    <div className="event" style={event.style}>
      <a className="inner" style={{backgroundColor: event.color}} href={event.url}>
        {event.react}
        <div className="time">{time(event.start)}-{time(event.end)}</div>
      </a>
    </div>
  );
}

export default class Day extends React.Component {
  render() {
    const events = this.props.events.map(toReactEvent);
    return (
      <div className="weekday">
        <header>{this.props.title}</header>
        <div className="body">
          {events}
        </div>
      </div>
    );
  }
}
