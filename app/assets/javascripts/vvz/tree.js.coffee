class @Tree

  attributes: {}

  constructor: ->
    id = preload.rootID
    # @events = window.preload.events
    @vvzs = {}
    @attributes.root = @getVvz(id)

  getRoot: ->
    @attributes.root

  getVvz: (id) =>
    return @vvzs[id] if id of @vvzs
    data = preload.tree[id]
    model =
      id: id
      name: data[0]
      childIDs: data[1]
      isLeaf: data[1] == null
    @vvzs[id] = model

  getVvzs: (ids) ->
    vvzs = (@getVvz(id) for id in ids)

  getEvent: (id) =>
    data = @events[id]
    model =
      id: id
      name: data[0]
      isEvent: true
      eventType: data[1]

  # asyncGetEventNodes: (ids) ->
  #   @asyncLoadMissingEventNodes(ids).pipe =>
  #     events = (@getEvent(id) for id in ids)

  ajaxError: (a,b,c) -> console.error("ajax error", a,b,c)

  # cacheEventNodeResponse: (data) => _.extend(@events, data)

  # asyncLoadMissingEventNodes: (ids) ->
  #   defer = $.Deferred()
  #   missing = _.reject(ids, (id) => id of @events)

  #   if missing.length == 0
  #     defer.resolve()
  #   else
  #     jqXHR = $.getJSON("/vvz/preload.json", {ids: ids.join(",")})
  #     jqXHR.fail(@ajaxError, defer.reject)
  #     jqXHR.done(@cacheEventNodeResponse, defer.resolve)

  #   defer.promise()

  asyncLoadEvent: (eventID) ->
    $.getJSON("/events/#{eventID}.json").fail(@ajaxError)

  asyncLoadEventNodes: (leafNodeID) ->
    jqXHR = $.getJSON("/vvz/preload.json", {id: leafNodeID})
    jqXHR.fail(@ajaxError)
    jqXHR

class @VvzDataStore

  constructor: () ->
    @tree = new Tree

  getNode: (nodeID, eventID)->
    if eventID
      events = this.getVvz(nodeID).eventNodes
      node = _.find(events, (e) -> String(e.id) == eventID)
    else
      node = @getVvz(nodeID)
    node

  getVvz: (nodeID) ->
    @getVvzs([nodeID])[0]

  getVvzs: (nodeIDs) ->
    nodes = @tree.getVvzs(nodeIDs)
    for node in nodes
      node.url = "/vvz/#{node.id}"
      node.value = node.id

    sortedNodes = @_sortByName(nodes)

  asyncGetEventNodesByLeaf: (leafNode) ->
    defer = $.Deferred()
    if leafNode.eventNodes
      defer.resolve(leafNode.eventNodes)
    else
      @tree.asyncLoadEventNodes(leafNode.id)
        .then (eventNodes) => @itemifyEventNodes(eventNodes, leafNode.id)
        .done (eventNodes) -> leafNode.eventNodes = eventNodes
        .done(defer.resolve)
    defer.promise()

  itemifyEventNodes: (eventNodes, leafNodeID) ->
    for eventNode in eventNodes
      eventNode.url = "/vvz/#{leafNodeID}/events/#{eventNode.id}"
      eventNode.value = "#{leafNodeID}/#{eventNode.id}"
    eventNodes

  # asyncGetEventNode: (leafNodeID, eventID) ->
  #   promise = @asyncGetEventNodes(leafNodeID, [eventID])
  #   promise.pipe (eventNodes) -> eventNodes[0]

  asyncGetEvent: (eventID) ->
    @tree.asyncLoadEvent(eventID)

  # only event nodes
  # not complete events
  # asyncGetGroupedEventNodes: (leafNodeID, eventIDs) ->
  #   promise = @asyncGetEventNodes(leafNodeID, eventIDs)
  #   promise.pipe (eventNodes)=>
  #     groups = @_sortAndGroupEvents(eventNodes)

  groupEventNodes: (models) =>
    sortedModels = @_sortByName(models)
    groups = _.groupBy(sortedModels, (model) -> model["eventType"] || "")
    json_groups = ({title: titel, items: items} for titel, items of groups)
    sortedGroups = _.sortBy(json_groups, (g) -> g.title )

  _sortByName: (items)-> _.sortBy(items, (i)-> i.name)
