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
      daysToShow : 7,
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
         return 500; //$(window).height() - $("h1").outerHeight() - 1;
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
      var year = new Date().getFullYear();
      var month = new Date().getMonth();
      var day = new Date().getDate();

      var new_events = [];
      $(events).each(function(i, e) {
         var new_event = {
            "start": new Date(e.start),
            "end": new Date(e.end),
            "title": e.title,
            "id": e.id,
            "url": e.url
         };
         new_events.push(new_event)
      });

      //console.log(new_events);
      return {events : new_events};
   };

});



