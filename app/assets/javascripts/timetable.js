//= require jquery-ui-1.8rc3.custom.min
//= require jquery.weekcalendar

$(document).ready(function() {
   var $calendar = $('#calendar');
   var id = 10;

   $calendar.empty()
   $calendar.weekCalendar({
      timeslotsPerHour : 4,
      allowCalEventOverlap : true,
      overlapEventsSeparate: true,
      firstDayOfWeek : 1,
      businessHours :{start: 7, end: 20, limitDisplay: true },
      daysToShow : 6,
      use24Hour: true,
      readonly: true,
      dateFormat: "",
      timeFormat : "H:i",
      timeSeparator : " - ",
      longDays: ["Sonntag", "&nbsp;&nbsp;Montag&nbsp;&nbsp;", "&nbsp;Dienstag&nbsp;", "&nbsp;Mittwoch&nbsp;", "Donnerstag", "&nbsp;Freitag&nbsp;", "Samstag", "Sonntag"],
      buttons : false,
      scrollToHourMillis: 0,
      timeslotHeight: 15,
      height : function($calendar) {
         return 830; //$(window).height() - $("h1").outerHeight() - 1;
      },
      // eventRender : function(calEvent, $event) {
      // },
      eventClick : function(calEvent, $event) {
         // redirect to the event page
         window.location.href = calEvent.url;
      },
      data : function(start, end, callback) {
         //console.log("se", {s:start, e:end})
         callback(getEventData());
      }
   });

   function getEventData() {
      var new_events = [];
      _.each(events, function(event) {
         var s = event.start, e = event.end;
         var new_event = {
            "start": new Date(s[0], s[1]-1, s[2], s[3], s[4], s[5]),
            "end": new Date(e[0], e[1]-1, e[2], e[3], e[4], e[5]),
            "title": event.title,
            "id": event.id,
            "url": event.url
         };
         new_events.push(new_event)
      });
      return {events : new_events};
   };

});



