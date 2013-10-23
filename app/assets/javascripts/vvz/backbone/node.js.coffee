class Model extends Backbone.Model
  #class: "Node:Model",

  defaults:
    children: []
    active: false

  initialize: ->
    #@set("url", @url)

  activate: ->
    # console.log "aktivate", this
    @set(active: true)

  deactivate: ->
    @set(active: false)

  getChild: (id) ->
    children = @get("children")
    match = _.find(children, (child) -> child.id == id)

  isEvent: ->
    @get("isEvent")

  url: ->
    if @isEvent()
      "/vvz/#{@get("parent").id}/events/#{@id}"
    else
      "/vvz/#{@id}"


class View extends Backbone.View
  #class: "Node:View",

  template: HoganTemplates["vvz/templates/item"]

  events:
    "click": "onClick"

  initialize: ->
    @model.bind('change', @render, this)
    @render()
    @delegateEvents(@events)

  render: ->
    data = @model.toJSON()
    data.url = @model.url()
    html = @template.render(data)
    $(@el).html(html)
    if @model.get("active")
      $(@el).find("a").focus()
    return this

  onClick: (event) =>
    # console.log "click", this
    unless event.ctrlKey || event.metaKey
      @model.activate()
      return false


class Data

  attributes: {}

  parse: (item) ->
    if item[2] == 1
      children = []
      isEvent = true
      eventType = item[3]
    else
      children = item[3]
      children = (@parse(child) for child in children)
      isEvent = false

    node = new Model
      id: item[0],
      name: item[1],
      children: children,
      isEvent: isEvent,
      eventType: eventType

    for child in children
      child.attributes.parent = node

    node

  seed: (node) ->
    @attributes.seed_data = node
    @attributes.root = @parse(node)


  getPath: (id_array) ->
    rootID = id_array.shift()
    parent = @attributes.root
    if parent.id != rootID
      console.error("Path does not exist! Root ID wrong.", {rootID: parent.id, id: rootID})

    getChildByID = (id) ->
      child = parent.getChild(id)
      if !child
        console.error("Path does not exist!", {path: id_array, id: id})
      child

    path = (getChildByID(id) for id in id_array)

  getRoot: ->
    @attributes.root


vvz.Node =
  View: View
  Model: Model
  Tree: new Data()

