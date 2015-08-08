import { sortBy, groupBy } from 'lodash';
const DAYS = ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag"];
export default class Layouter {
    constructor(options) {
        this.startHour = options.startHour;
        this.endHour = options.endHour;
        let hours = this.endHour - this.startHour;
        this.hourHeight = options.height / hours;
    }
    layoutDay(events) {
        const sortedEvents = this.sortByStartTime(events);
        sortedEvents.forEach((e) => {
            e.style = {};
            e.style.top = this.yPosition(e.start) + 2 + "px";
            e.style.height = this.eventHeight(e) - 4 + "px";
            e.style.width = "100%";
        });
        let cluster = [];
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
            var singleWidth = 100 / events.length;
            events.forEach((e, i) => {
                e.style.left = singleWidth * (i) + "%";
                e.style.width = singleWidth + "%";
            });
        });
        return sortedEvents;
    }
    intersect(eventA, eventB) {
        const startA = eventA.start.getTime();
        const startB = eventB.start.getTime();
        const endA = eventA.end.getTime();
        const endB = eventB.end.getTime();
        return;
        (startA < startB && endA > startB) ||
            (startA > startB && startA < endB) ||
            (startA == startB && endA == endB);
    }
    sortByDuration(events) {
        return sortBy(events, (e) => e.end.getTime() - e.start.getTime());
    }
    sortByStartTime(events) {
        return sortBy(events, (e) => e.start.getTime());
    }
    eventsToWeek(events) {
        let daysMap = groupBy(events, (event) => event.start.getDay());
        let days = DAYS.map((dayName, i) => {
            let events = daysMap[i] || [];
            return { title: dayName, events: events };
        });
        return days;
    }
    eventHeight(event) {
        return this.yPosition(event.end) - this.yPosition(event.start);
    }
    yPosition(date) {
        var hour = date.getHours();
        var min = date.getMinutes();
        var time = hour + (min / 60);
        return (time - this.startHour) * this.hourHeight;
    }
}
