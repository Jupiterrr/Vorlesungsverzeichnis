
class window.HomeControl

  template = '<div class="btn btn-label map-controll-btn"></div>'

  constructor: (controlDiv, map, options) ->
    @$controlDiv = $(controlDiv)
    @map = map
    @options = options
    @zoom = @options.zoom
    @latlng = new google.maps.LatLng(options.latlng[0], options.latlng[1])
    controlDiv.style.padding = '5px'
    $el = $(template).appendTo(@$controlDiv)
    $el.text(@options.text)
    $el.on("click", => @setCenter() )

  setCenter: ->
    @map.setZoom(@zoom);
    @map.setCenter(@latlng);
