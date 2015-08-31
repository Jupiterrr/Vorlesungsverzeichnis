//= require jquery-ui-1.8rc3.custom.min
//= require jquery.weekcalendar

$(document).ready(function() {
   var $calendar = $('#calendar');
   var id = 10;
   var toCurrentWeek = weekMapper(new Date());

   var showSaturday = _.any(window.events, function(e) {
      var s = e.start;
      var date = new Date(s[0], s[1]-1, s[2], s[3], s[4], s[5])
      return date.getDay() == 6;
   });

   var myEvents = getEventData();

   if ($(".print").length) {
      var minH = _.min(myEvents, function(e) { return e.start_h; });
      var maxH = _.max(myEvents, function(e) { return e.end_h; });
      var startH = minH.start_h < 8 ? minH.start_h : 8;
      var endH = maxH.end_h > 18 ? maxH.end_h : 18;
   } else {
      var startH = 7;
      var endH = 20;
   }


   $calendar.empty()
   $calendar.weekCalendar({
      timeslotsPerHour : 4,
      allowCalEventOverlap : true,
      overlapEventsSeparate: true,
      firstDayOfWeek : 1,
      businessHours :{start: startH, end: endH, limitDisplay: true },
      daysToShow : showSaturday ? 6: 5,
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
         return 830;
         // return $(window).height() - $("h1").outerHeight() - 1;
      },
      eventRender : function(calEvent, $event) {
         $event.css({
           backgroundColor: calEvent.color
         });
      },
      // eventClick : function(calEvent, $event) {},
      data : {events : myEvents}
   });
   $calendar.find(".wc-cal-event").on("click", function(e) {
      var url = $(this).data("calEvent").url;
      if (e.metaKey) { window.open(url); }
      else { window.location = url; }
   })

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

   function getEventData() {
      var new_events = [];
      _.each(events, function(event) {
         var s = event.start, e = event.end;
         var startDate = new Date(s[0], s[1]-1, s[2], s[3], s[4], s[5]);
         var endDate = new Date(e[0], e[1]-1, e[2], e[3], e[4], e[5]);
         var new_event = {
            "start": toCurrentWeek(startDate),
            "end": toCurrentWeek(endDate),
            "title": event.title,
            "id": event.id,
            "url": event.url,
            "color": event.color,
            "start_h": s[4] == 0 ? s[3] : s[3]-1,
            "end_h": e[4] == 0 ? e[3] : e[3]+1
         };
         new_events.push(new_event)
      });
      return new_events;
   };

});



