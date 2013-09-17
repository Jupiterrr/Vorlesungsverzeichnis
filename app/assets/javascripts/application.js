// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//1= require jquery
//1= require jquery_ujs
//2= require twitter/bootstrap
//1= require_tree .

//= require search

//1= require twitter/bootstrap-typeahead
//0= require twitter/bootstrap/bootstrap-tooltip
//= require lib/typeahead.min
//= require twitter/bootstrap-dropdown

function accordionyziseThis(parent) {
  parent = parent || $(document.body);
  parent.find('a[rel=collapse]').click(function() {
    selector = $(this).data("target")
    $(selector).toggleClass("hide")
  })
}

$(function() {
  $(".ical_url input").on("click", function() {
    $(this).select();
  })
  $('a[rel=tooltip]').tooltip()
  $('#signout').tooltip()
  accordionyziseThis()


  var isCurrentlyMobile = isMobile();
  $("body").toggleClass("mobile", isCurrentlyMobile);
  $(window).resize(function() {
    if (isCurrentlyMobile != isMobile()) {
      isCurrentlyMobile = !isCurrentlyMobile;
      $("body").toggleClass("mobile", isCurrentlyMobile);
      $(window).trigger("styleChange", isCurrentlyMobile);
    }
  });

  $('.dropdown-toggle').dropdown()

  $(window).on("styleChange", function(event, isMobile) {
    //console.log("stylechange", isMobile)
  })

  $("#js-exam-dates-disciplines").change(function(a, b) {
    window.location = "#" + this.value
  })
})

function isMobile() {
  var size = window.getComputedStyle(document.body,':after').getPropertyValue('content');
  return size.indexOf("mobile") !=-1;
}

$(function() {
  $("#menue-btn").click(function() {
    $("#main-nav").toggleClass("active");
    return false;
  })
  $(window).click(function() {
    $("#main-nav").removeClass("active");
  });

})
