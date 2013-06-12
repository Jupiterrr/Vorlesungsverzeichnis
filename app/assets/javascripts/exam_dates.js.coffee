# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  #$('.calendar-day').tooltip()
  last = null
  $('html').click ->
    if last
      $(last).popover('hide')
      last = null

  $('.calendar-day[data-exams]').click (e)->
    e.stopPropagation()

    if last
      $(last).popover('hide')


    if last == this
      last = null
    else
      content = $(this).data("exams").map (e)->
        "<div><a href=\"#{e.url}\">#{e.name}<a></div>"
      content = content.join("")
      $(this).popover
        content: content,
        trigger: "manual",
        placement: "top",
        title: $(this).data("date"),
        html: true,
        animation: false
      $(this).popover("show")
      last = this
