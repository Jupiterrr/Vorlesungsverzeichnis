class Collection extends Backbone.Collection
  #class: "Colum:Collection"
  model: vvz.Node.Model

  initialize: (models, options) ->
    if options && model = @get(options.activeID)
      @activeModel = model.activate()

    @bind "change:active", (changedModel, active) =>
      if active == true && @activeModel != changedModel
        # console.log "change:active:?"
        @trigger("change:active:true", changedModel, active)

    @bind "change:active:true", (changedModel) ->
      # console.log "change:active:true"
      @deactivateActive()
      @activeModel = changedModel

  # load: (id) ->
  #   data = vvz.Node.Model.getByID(id)
  #   @add(data)

  comparator: (m) ->
    m.get("name")

  deactivateActive: ->
    if @activeModel
      @activeModel.deactivate()
      @activeModel = null

  navDown: ->
    currentIndex = @indexOf(@activeModel)
    if nextItem = @at(currentIndex+1)
      nextItem.activate()

  navUp: ->
    currentIndex = @indexOf(@activeModel)
    if nextItem = @at(currentIndex-1)
      nextItem.activate()

class CollumnView extends Backbone.View
  # class: "Colum:View"
  template: HoganTemplates["vvz/templates/colum"].render
  className: "spalte"

  hide: -> return
  show: -> return

class NodeCollumnView extends CollumnView
  # class: "NodeColum:View",
  events:
    "navDown": "navDown",
    "navUp": "navUp",
    "navRight": "navRight"


  initialize: ->
    # console.log "NodeCollumnView init", @cid, this
    @collection.sort()
    #children = _.sortBy(children, (child) -> child.get("name"))

    @nodes = [] # NodeViews

    # init views
    for item in @collection.models
      view = new vvz.Node.View
        model: item
        parent: this
      @nodes.push(view)
    @render()

    # prevent actions while seed is running
    @listenTo(@collection, "change:active:true", (m)=>
      @open(m) if vvz.ready
    )

  open: (model)=>
    # console.log "open", @cid, model.get("name"), model
    view = @createChildView(model)
    vvz.columnManager.addAfter(this, view)
    @setHistory(model)

  setHistory: (model) ->
    pageTitle = model.get("name")
    pageUrl = model.url()
    if history && history.replaceState
      history.replaceState({}, pageTitle, pageUrl)
    $('title').text(pageTitle)
    vvz.trackPageview(pageTitle, pageUrl)

  close: ->
    # console.log "close", @collection.activeModel.get("name")
    vvz.columnManager.removeAfter(this)

  render: ->
    el = $(@el)
    el.empty()
    el.addClass("js")
    if @nodes.length > 0
      for view in @nodes
        el.append(view.el)
    else
      el.addClass("empty")
      el.append("Keine Veranstaltungen vorhanden")

  remove: ->
    # @collection.deactivateActive()
    super

  show: ->
    for view in @nodes
      $(view.el).find("a").removeAttr("tabindex")

  hide: ->
    if @nodes.length > 1
      for view in @nodes
        $(view.el).find("a").attr("tabindex", -1)

  createChildView: (model) ->
    if model.isEvent()
      view = new vvz.Event.EventView(parent: model)
    else
      collection = new vvz.Colum.Collection(model.get("children"))
      model.set("childCollection", collection)
      view = new vvz.Colum.View(collection: collection)
    return view

  navDown: ->
    @collection.navDown()

  navUp: ->
    @collection.navUp()

  navRight: ->
    collection = @collection.activeModel.get("childCollection")
    if collection && collection.length > 0
      collection.first().activate()


vvz.Colum =
  Collection: Collection
  View: NodeCollumnView
  CollumnView: CollumnView

