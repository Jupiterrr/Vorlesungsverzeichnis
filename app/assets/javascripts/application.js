//= require jquery/jquery
//= require bootstrap-css/js/bootstrap
//= require search
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

$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
  }
});

$(function() {
  $("#menue-btn").click(function() {
    $("#main-nav").toggleClass("active");
    return false;
  })
  $(window).click(function() {
    $("#main-nav").removeClass("active");
  });

})
