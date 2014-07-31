'use strict';

function HomeControl(controlDiv, map, options) {
  var that = this;
  var template = '<div class="btn btn-label map-controll-btn"></div>';
  this.$controlDiv = $(controlDiv);
  this.map = map;
  this.options = options;
  this.zoom = this.options.zoom;
  this.latlng = new google.maps.LatLng(options.latlng[0], options.latlng[1]);
  controlDiv.style.padding = '5px';
  var $el = $(template).appendTo(this.$controlDiv);
  $el.text(this.options.text);
  $el.on("click", function() { that._setCenter(); });
}

HomeControl.prototype = {
  _setCenter: function setCenter() {
    this.map.setZoom(this.zoom);
    this.map.setCenter(this.latlng);
  }
};
