/// <reference path="lodash.d.ts" />
import {sortBy, groupBy} from 'lodash';

interface Event {
  title: string;
  start: Date;
  end: Date;
  style?: {
    width?: string;
    left?: string;
    height?: string;
    top?: string;
  }
}

interface WeekDay {
    title: string;
    events: Event[];
}

interface LayouterConfig {
  startHour: number;
  endHour: number;
  height: number;
}

/*interface IntersectionEvent extends Event {
  intersects: Event[];
}*/

const DAYS = ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"];

export default class Layouter {

  private startHour: number;
  private endHour: number;
  private hourHeight: number;

  constructor(options: LayouterConfig) {
      this.startHour = options.startHour;
      this.endHour = options.endHour;
      let hours = this.endHour - this.startHour;
      this.hourHeight = options.height / hours;
  }

  layoutDay(events: Event[]): Event[] {
    const sortedEvents = this.sortByStartTime(events);
    sortedEvents.forEach((e) => {
      e.style = {};
      e.style.top = this.yPosition(e.start) +2 + "px";
      e.style.height = this.eventHeight(e) -4 + "px";
      e.style.width = "100%";
    });

    let cluster : Event[][] = [];
    let currentCluster = [];
    let lastEnd = 0;
    sortedEvents.forEach((event) => {
      if (lastEnd < event.start.getTime()) {
        cluster.push(currentCluster);
        currentCluster = [];
      }
      lastEnd = Math.max(lastEnd, event.end.getTime());
      currentCluster.push(event);
    });
    cluster.push(currentCluster);

    cluster.forEach((events) => {
      var singleWidth = 100/events.length;
      events.forEach((e, i) => {
        e.style.left = singleWidth*(i) + "%";
        e.style.width = singleWidth + "%";
      })
    });

    return sortedEvents;
  }

  intersect(eventA: Event, eventB: Event): boolean {
    const startA = eventA.start.getTime();
    const startB = eventB.start.getTime();
    const endA = eventA.end.getTime();
    const endB = eventB.end.getTime();
    return
      (startA < startB && endA > startB) || // A starts before B
      (startA > startB && startA < endB) || // B starts before A
      (startA == startB && endA == endB);   // exact same time
  }

  /*hasIntersection(events: Event[], eventB: Event): boolean {
    return events.some((eventA) => {
      return this.intersect(eventA, eventB) || this.intersect(eventB, eventA)
    });
  }*/

  sortByDuration(events: Event[]): Event[] {
    return sortBy(events, (e) => e.end.getTime() - e.start.getTime());
  }

  sortByStartTime(events: Event[]): Event[] {
    return sortBy(events, (e) => e.start.getTime());
  }

  eventsToWeek(events: Event[]): WeekDay[] {
    let daysMap = groupBy(events, (event) => event.start.getDay());
    let days = DAYS.map((dayName, i) => {
      let events = daysMap[i] || [];
      return {title: dayName, events: events};
    });
    return days;
  }

  eventHeight(event: Event): number {
    return this.yPosition(event.end) - this.yPosition(event.start);
  }

  yPosition(date: Date): number {
    var hour = date.getHours();
    var min = date.getMinutes();
    var time = hour + (min/60)
    return (time - this.startHour) * this.hourHeight;
  }

}
