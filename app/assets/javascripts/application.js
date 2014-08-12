//= require jquery/jquery
//= require bootstrap-css/js/bootstrap
//= require search
//= require post
//= require comments
//= require lib/typeahead.min
//= require twitter/bootstrap-dropdown
//= require lib/underscore-min
//= require dialog-polyfill/dialog-polyfill

function accordionyziseThis(parent) {
  parent = parent || $(document.body);
  parent.find('[data-toggle=collapse-js]').click(function(event) {
    if (event.target.tagName == "A") return;
    selector = $(this).data("target") || $(this).parent().find(".collapse-body")
    $(selector).toggleClass("active")
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
  //var size = window.getComputedStyle(document.body,':after').getPropertyValue('content');
  //return size.indexOf("mobile") !=-1;
  return $(window).width() < 767;
}

$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
  }
});


$(function() {
  var menueBtn = $("#menue-btn");
  var mainNav = $("#main-nav");
  var active = false;

  function toggle(state) {
    active = state;
    menueBtn.toggleClass("active", active);
    mainNav.toggleClass("active", active);
  }

  menueBtn.click(function() { toggle(!active); return false; });
  $(document.body).click(function() { toggle(false); });
});

