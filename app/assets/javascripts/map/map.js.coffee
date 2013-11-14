class MapRouter

  constructor: (initPoi, map) ->
    @map = map
    @options =
      history: window.history && window.history.replaceState
    @currentPoi = initPoi
    @baseTitle = document.title.split(" - ")[1] || document.title

    window.onpopstate = (event) =>
      # console.log "popstate show", event.state
      if event && event.state
        if event.state.noPoi
          @map.closeActive()
        else
          poi = event.state
          @openPoi(poi, true)

    if @currentPoi
      delay 1000, =>
        @map.showMarker(@currentPoi)
        if @options.history
          state = @copyPoi(@currentPoi)
          window.history.replaceState(state , document.title, window.location.href);
    else
      if @options.history
        window.history.replaceState({noPoi: true} , document.title, window.location.href);

  openPoi: (poi, force) =>
    @currentPoi = poi
    @map.showMarker(poi)
    @setTitle(poi)
    if @options.history && !force
      state = @copyPoi(poi)
      window.history.pushState(state, @pageTitle(poi), "/map/#{poi.id}")

  copyPoi: (poi) ->
    copy = {
      address: poi.address,
      building_no: poi.building_no,
      id: poi.id,
      lat: poi.lat,
      lng: poi.lng,
      name: poi.name,
      type: poi.type
    }

  pageTitle: (poi) ->
    pageTitle = "#{poi.name} - #{@baseTitle}"

  setTitle: (poi) ->
    document.title = @pageTitle(poi)
    $("#poi-title-js").text(poi.name)

class Map

  infoBoxTemplate: HoganTemplates["map/templates/infobox"]

  constructor: (el, poi) ->
    @el = el
    @initPoi = poi

    if poi
      center = new google.maps.LatLng(poi.lat, poi.lng)
    else
      center = new google.maps.LatLng(49.012419, 8.41527)

    @mapOptions =
      zoom: 16,
      center: center,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    # var canvas = document.getElementById(@mapID);
    @map = new google.maps.Map(@el, @mapOptions)

    layerControlDiv = document.createElement('div')
    layerControl = new LayerControl(layerControlDiv, @map)

    layerControlDiv.index = 1
    @map.controls[google.maps.ControlPosition.TOP_RIGHT].push(layerControlDiv)

    homeControlDiv = document.createElement('div')
    homeControlDiv.index = 1
    @map.controls[google.maps.ControlPosition.TOP_RIGHT].push(homeControlDiv)
    homeControlDiv.classList.add "btn-group"

    homeControl = new HomeControl(homeControlDiv, @map, text: "Campus Süd", latlng: [49.012419, 8.41527], zoom: 16 )
    homeControl2 = new HomeControl(homeControlDiv, @map, text: "Campus Nord", latlng: [49.096295, 8.431363], zoom: 15)



    @infoBox = @createInfoBox()
    @tooltip = @createTooltip()

    @search = new MapSearch($('#map-search'))
    @router = new MapRouter(@initPoi, this)

    $(@search).on("select", (event, poi) =>
      console.log "select"
      @router.openPoi(poi)
    )

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

    google.maps.event.addListener(@map, "click", =>
      @closeActive()
    )





  showMarker: (poi) ->
    # console.log("show", poi, poi.name)
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


