class window.GroupSelector

  constructor: (map_class) ->
    @el = $("#categories_selector")
    @map_class = map_class
    @items = {}
    @el.find("input[type=checkbox]").on("change", @onChange)
    @groups = {}

  onChange: (e) =>
    input = $(e.target)
    id = $(input).data("group-id")
    if e.target.checked
      @show(id, input.data("pois"), input.data("color"))
    else
      @hide(id)

  show: (groupID, poiIDs, color) ->
    # translate the ids to pois
    pois = (@map_class.poiIndex[id] for id in poiIDs)
    # addCircles can block the ui, so defer it
    delay 0, => @addGroup(pois, color, groupID)
      
  hide: (groupID) ->
    group = @groups[groupID]
    marker.setMap(null) for marker in group
    delete @groups[groupID]

  addGroup: (pois, color, groupID) ->
    group = @map_class.addCircles(pois, color)
    for marker in group
      $(marker).on("cclick", (e, poi) => @map_class.showMarker(poi))
    @groups[groupID] = group
