
class window.LayerControl

  template = HoganTemplates["map/templates/layer_control"]

  constructor: (controlDiv, map) ->
    @$controlDiv = $(controlDiv)
    @map = map
    @showOverlay = false

    controlDiv.style.padding = '5px'
    @$controlDiv.append( template.render() )
    @checkbox = @$controlDiv.find('input[type="checkbox"]')
    @checkbox.prop("checked", @showOverlay);

    $(controlDiv).on("click", => @change() )
    @change() unless isMobile() # show kit map

  change: ->
    @showOverlay = !@showOverlay
    if @showOverlay
      @initOverley() if !@kitOverlay
      @kitOverlay.setMap(@map)
    else
      @kitOverlay.setMap(null)
    @checkbox.prop("checked", @showOverlay);
    @$controlDiv.trigger("change")

  # add KIT Overlay
  initOverley: () ->
    #  Bounds of overlay
    imageBounds = new google.maps.LatLngBounds(
      new google.maps.LatLng(49.007537,8.4014),
      new google.maps.LatLng(49.022033, 8.4323)
    )
    #  Overlay
    @kitOverlay = new google.maps.GroundOverlay(
      '/Campus-Sued.png',
      imageBounds, {editable: true}
    )
    @kitOverlay.setMap(@map)
    google.maps.event.addListener(@kitOverlay, "click", =>
      google.maps.event.trigger(@map, "click")
    )
