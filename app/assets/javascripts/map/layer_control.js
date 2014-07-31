'use strict';

function LayerControl(controlDiv, map) {
  var that = this;
  var template = HoganTemplates["map/templates/layer_control"];
  this.$controlDiv = $(controlDiv);
  this.map = map;
  this.showOverlay = false;

  controlDiv.style.padding = '5px';
  this.$controlDiv.append( template.render() );
  this.checkbox = this.$controlDiv.find('input[type="checkbox"]');
  this.checkbox.prop("checked", this.showOverlay);

  $(controlDiv).on("click", function() { that._change() } );
  if (!isMobile()) this._change(); // show kit map;
}

LayerControl.prototype = {
  _change: function change() {
    this.showOverlay = !this.showOverlay;
    if (this.showOverlay) {
      if (!this.kitOverlay) this._initOverley();
      this.kitOverlay.setMap(this.map);
    } else {
      this.kitOverlay.setMap(null);
    }
    this.checkbox.prop("checked", this.showOverlay);
    this.$controlDiv.trigger("change");
  },

  // add KIT Overlay
  _initOverley: function initOverley() {
    var that = this;
    
    // Bounds of overlay
    var imageBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(49.007537,8.4014),
      new google.maps.LatLng(49.022033, 8.4323)
    );

    // Overlay
    this.kitOverlay = new google.maps.GroundOverlay(
      '/Campus-Sued.png',
      imageBounds, {editable: true}
    );

    this.kitOverlay.setMap(this.map);
    google.maps.event.addListener(this.kitOverlay, "click", function() {
      google.maps.event.trigger(that.map, "click");
    });
  }
};
