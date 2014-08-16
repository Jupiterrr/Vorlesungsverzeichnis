'use strict';

(function(root) {
  
  var poiIndex = {};
  _.each(window.pois, function(poi) {
    poiIndex[poi.id] = poi;
  });

  function produceGeoJson(poiID, group) {
    var poi = poiIndex[poiID];

    if (window.poi && window.poi.id == poi.id) poi.selected = true;
    return {
      type: "Feature",
      properties: _.extend({group: group},poi),
      id: poi.id,
      geometry: {
        type: "Point",
        coordinates: [poi.lng, poi.lat]
      }
    }
  }

  function xlatlng(latlng) {
    return new google.maps.LatLng(latlng[0], latlng[1]);
  }

  function dialog(html) {
    var styledModal = document.createElement("dialog");
    styledModal.setAttribute("id", "styledModal");
    styledModal.innerHTML = html;
    document.body.appendChild(styledModal);
    dialogPolyfill.registerDialog(styledModal);
    
    // Get the buttons.
    var styledModalBtn = document.getElementById('launchStyledModal');
    var closeBtns = document.querySelectorAll('dialog .close');

    
    for (var i = 0; i < closeBtns.length; i++) {
      closeBtns[i].addEventListener('click', function(e) {
        this.parentNode.close();
        document.body.removeChild(styledModal);
      });
    }

    styledModal.showModal();
    return styledModal;
  }


  function KitHubMap(el, poi) {
    var that = this;
    this.el = el;
    this.initPoi = poi;
    this.infoBoxTemplate = HoganTemplates["map/templates/infobox"];
    this.baseTitle = document.title.split(" · ")[1] || document.title;

    this.options = {
      defaultCenter: [49.012419, 8.41527]
    };

    var center = poi ? [poi.lat, poi.lng] : this.options.defaultCenter;
    
    this._initMap(center);
    this._initMapControlls(this.map);
    this._initInfoWindow();
    this._initTooltip();
    this._initDataLayersAndButtons();


    google.maps.event.addListener(this.map, "click", function() {
      if (that.infowindow) that.infowindow.close();
    })

    this.search = new MapSearch($('#map-search'))
    
    $(this.search).on("select", function(event, poi) {
      // console.log("select");
      that.select(poi.id);
    })

    if (poi) {
      that.select(poi.id);
    }
  }

  KitHubMap.prototype = {

    _initMap: function initMap(center) {
      var mapOptions = {
        zoom: 16,
        center: xlatlng(center),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        streetViewControl: false,
        panControl: false,
        mapTypeControlOptions: {
          style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
        },
        zoomControlOptions: {
          style: google.maps.ZoomControlStyle.SMALL
        }
      };
      
      console.log("init map")
      this.map = new google.maps.Map(this.el, mapOptions);
    },

    _initMapControlls: function initMapControlls(map) {
      var layerControlDiv = document.createElement('div');
      var layerControl = new LayerControl(layerControlDiv, this.map);

      layerControlDiv.index = 1;
      this.map.controls[google.maps.ControlPosition.TOP_RIGHT].push(layerControlDiv);

      var homeControlDiv = document.createElement('div');
      homeControlDiv.index = 1;
      this.map.controls[google.maps.ControlPosition.TOP_RIGHT].push(homeControlDiv);
      homeControlDiv.classList.add("btn-group");

      var homeControl = new HomeControl(homeControlDiv, this.map, {text: "Campus Süd", latlng: [49.012419, 8.41527], zoom: 16} );
      var homeControl2 = new HomeControl(homeControlDiv, this.map, {text: "Campus Nord", latlng: [49.096295, 8.431363], zoom: 15});
    },

    _initInfoWindow: function initInfoWindow() {
      this.infowindow = new google.maps.InfoWindow();
    },

    _setInfowindowTo: function setInfowindowTo(poi, marker) {
      var that = this;

      var boxText = document.createElement("div");
      boxText.className = "infowindow"
      boxText.innerHTML = this.infoBoxTemplate.render({
        poi: poi
      });

      this.infowindow.setContent(boxText);
      this.infowindow.open(this.map, marker);

      $(boxText).find("#map-share-link-js").click(function() {
        that._shareDialog(poi);
      });
    },

    _shareDialog: function _shareDialog(poi) {
      var tmpl = HoganTemplates["map/templates/modal"];
      var html = tmpl.render({url: "http://www.kithub.de/map/"+poi.id});
      dialog(html);
    },

    select: function select(ID, panTo){
      console.log("select poi")
      var that = this;
      var poi = poiIndex[ID];
      var position = xlatlng([poi.lat, poi.lng]);

      if (!this.marker) {
        this.marker = new google.maps.Marker({map: this.map, zIndex: 500});
        google.maps.event.addListener(this.marker, 'click', function(a,b,c) {
          // this.data can change so use this.data
          that._setInfowindowTo(this.data, this);
        });
      }

      this.marker.setOptions({
        position: position,
        data: poi
      });

      this._setInfowindowTo(poi, this.marker);

      if (panTo !== false) this._panTo(poi);

      var title = poi.name + " · " + this.baseTitle;
      document.title = title;
      $("#poi-title-js").text("");
      if (window.history)
        window.history.replaceState(null , title, "/map/"+poi.id);
    },

    _setTooltipFor: function setTooltipFor(feature) {
      if (this.lastSelectedFeature === feature) return;
      var poi = poiIndex[feature.getId()];
      var boxText = document.createElement("div");
      boxText.className = "tooltipi";
      boxText.innerHTML = poi.name;
      this.tooltip.setContent(boxText);
      this.tooltip.open(this.map, {
        getPosition: function() { return feature.getGeometry().get(); }
      });
    },

    _hideTooltip: function hideTooltip() {
      this.tooltip.close();
    },

    _initTooltip: function() {
      var tooltip = new InfoBox({
        content: "",
        alignBottom: true,
        disableAutoPan: false,
        maxWidth: 300,
        pixelOffset: new google.maps.Size(-150, -13),
        zIndex: null,
        boxStyle: {
          opacity: 0.75,
          width: "300px",
        },
        closeBoxURL: "",
        infoBoxClearance: new google.maps.Size(1, 1),
        isHidden: false,
        pane: "floatPane",
        enableEventPropagation: false
      });
      this.tooltip = tooltip;
    },

    _layerStyling: function layerStyling(feature) {
      var style = {
        icon: {
          url: "/assets/pin-"+feature.getProperty("group").color.slice(1)+".png",
          anchor: new google.maps.Point(9, 9),
          scaledSize: new google.maps.Size(18, 18)
        }
      };
      return style;
    },

    _initDataLayer: function initDataLayer(group) {
      var that = this;
      var featureCollection = _.map(group.pois, function(poiID) {
        return produceGeoJson(poiID, group);
      });
      var geoData = {
        type: "FeatureCollection",
        features: featureCollection
      };
      var data = new google.maps.Data();
      data.addGeoJson(geoData);
      data.setStyle(this._layerStyling);

      data.addListener('click', function(event) {
        // console.log("click", event.feature);
        that.select(event.feature.getId(), false);
        that._hideTooltip();
      });

      data.addListener('mouseover', function(event) {
        that._setTooltipFor(event.feature);
      });

      data.addListener('mouseout', function(event) {
        that._hideTooltip();
      });

      return data;
    },

    _initDataLayersAndButtons: function initDataLayersAndButtons() {
      var that = this;
      _.each(groups, function(group) {
        var checkbox = document.getElementById("ccb" + group.id);
        if (!checkbox) return console.warn("Can't find checkbox!");
        checkbox.poiGroup = group;
        
        var data = that._initDataLayer(group);
        group.dataLayer = data;
      });

      $("#categories_selector input[type=checkbox]").on("change", function(e) {
        var group = e.target.poiGroup;
        group.dataLayer.setMap(e.target.checked ? that.map : null);
      })
    },

    _panTo: function panTo(poi) {
      this.map.panTo(xlatlng([poi.lat, poi.lng]))
    }

  };

  
  google.maps.event.addDomListener(window, 'load', function() {
    var el = document.getElementById('map_canvas');
    window.map = new KitHubMap(el, window.poi);
  });


})(this);
