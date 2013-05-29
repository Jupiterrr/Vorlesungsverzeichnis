class Map

  infoBoxTemplate: HoganTemplates["map/templates/infobox"]

  constructor: (el, poi) ->
    @el = el

    if poi
      center = new google.maps.LatLng(poi.lat, poi.lng)
    else
      center = new google.maps.LatLng(49.0118, 8.413081350509648)
    
    @mapOptions =
      zoom: 16,
      center: center,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    # var canvas = document.getElementById(@mapID);
    @map = new google.maps.Map(@el, @mapOptions)
    # @initOverley();

    @infoBox = @createInfoBox()
    @tooltip = @createTooltip()

    @search = new MapSearch($('#map-search'))
    $(@search).on("select", (event, poi) => @showMarker(poi))

    # selectView = new SelectView()
    # $(".edit").on("click", () => selectView.show())

    @groupSelector = new GroupSelector(this)

    delay 100, => @createPoiIndex()
    #  If the data-poi atribute is set with an serialized poi object
    #  then show it.
    #  You can render the index view with this poi as an alternative to
    #  to the show view.
    #  var poi = $("#map_canvas").data("poi");
    #  if (!!poi) { show(poi); }

    if poi
      delay 1000, => @showMarker(poi)

    google.maps.event.addListener(@map, "click", => @closeActive() )


  # add KIT Overlay
  # initOverley: () ->
  #   #  Bounds of overlay
  #   imageBounds = new google.maps.LatLngBounds(
  #     new google.maps.LatLng(49.007537,8.4014),
  #     new google.maps.LatLng(49.022033, 8.4323)
  #   )
  #   #  Overlay
  #   kitOverlay = new google.maps.GroundOverlay(
  #     '/Campus-Sued.png',
  #     imageBounds, {editable: true}
  #   )
  #   kitOverlay.setMap(@map)


  showMarker: (poi) ->
    console.log("show", poi, poi.name)
    @activeMarker.setMap(null) if @activeMarker
    @panTo(poi)
    @activeMarker = @addCircle(poi, "selected")    
    @addInfowindow(poi, @activeMarker)

  panTo: (poi) ->
    latlng = new google.maps.LatLng(poi.lat, poi.lng, false)
    @map.panTo(latlng)

  # Closes an active Infobox and set marker Icon to default
  closeActive: ->
    @infoBox.close()
    if @selectedMarker
      @selectedMarker.setIcon(@selectedMarker.defaultIcon)
      @selectedMarker = null

  addInfowindow: (poi, marker) ->
    @closeActive()

    @selectedMarker = marker
    marker.setIcon("/assets/pin-active.png")

    boxText = document.createElement("div")
    boxText.className = "custom-infowindow"
    boxText.innerHTML = @infoBoxTemplate.render
      poi: poi
      link: "/map/#{poi.id}"
            
    @infoBox.setContent(boxText)
    @infoBox.open(@map, marker)

  createInfoBox: ->
    new InfoBox
      content: ""
      alignBottom: true
      disableAutoPan: false
      maxWidth: 300
      pixelOffset: new google.maps.Size(-150, -25)
      zIndex: null
      boxStyle:
        opacity: 1
        width: "300px"
      closeBoxURL: ""
      infoBoxClearance: new google.maps.Size(1, 1)
      isHidden: false
      pane: "floatPane"
      enableEventPropagation: false

  addCircle: (poi, color) ->
    # console.log "add Circle", poi, color
    latlng = new google.maps.LatLng(poi.lat, poi.lng)
    image = "/assets/pin-#{color}.png"
    marker = new google.maps.Marker
      position: latlng
      map: @map
      icon: image
      defaultIcon: image

    @addTooltip(poi, marker) unless window.isMobile()
    google.maps.event.addListener(marker, "click", => @addInfowindow(poi, marker))
    marker
  
  addCircles: (pois, color) ->
    markers = (@addCircle(poi, color) for poi in pois)
  
  createTooltip: ->
    new InfoBox
      content: ""
      alignBottom: true
      disableAutoPan: false
      maxWidth: 300
      pixelOffset: new google.maps.Size(-150, -20)
      zIndex: null
      boxStyle:
        opacity: 0.75
        width: "300px"
      closeBoxURL: ""
      infoBoxClearance: new google.maps.Size(1, 1)
      isHidden: false
      pane: "floatPane"
      enableEventPropagation: false

  addTooltip: (poi, marker) ->
    google.maps.event.addListener marker, "mouseover", => 
      @showTooltip(marker, poi) unless @selectedMarker == marker
    google.maps.event.addListener(marker, "mouseout", => @tooltip.close())
    google.maps.event.addListener(marker, "click", => @tooltip.close())

  showTooltip: (marker, poi) ->
    boxText = document.createElement("div")
    boxText.className = "tooltipi"
    boxText.innerHTML = poi.name
    @tooltip.setContent(boxText)
    @tooltip.open(@map, marker)

  createPoiIndex: () ->
    index = {}
    (index[poi.id] = poi for poi in pois)
    @poiIndex = index
  


$(() ->
  el = $("#map_canvas")[0]
  window.map = new Map(el, window.poi) if el

  $('body').tooltip({
      selector: "a[rel=tooltip]"
  })

  $(".search-query").focus()
  # var view = new FormView();
  # view.show(pois[0]);
)


