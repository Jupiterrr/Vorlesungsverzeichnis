class Collection extends Backbone.Collection
  #class: "Colum:Collection"
  model: vvz.Node.Model
  
  initialize: (models, options) ->
    if options && model = @get(options.activeID)
      @activeModel = model.activate()

    @bind "change:active", (changedModel, active) -> 
      if active == true && @activeModel != changedModel
        @deactivateActive()
        @activeModel = changedModel

  # load: (id) ->
  #   data = vvz.Node.Model.getByID(id)
  #   @add(data)

  comparator: (m) ->
    m.get("name")

  deactivateActive: ->
    @activeModel.deactivate() if @activeModel


class CollumnView extends Backbone.View
  # class: "Colum:View"
  template: HoganTemplates["vvz/templates/colum"].render
  className: "spalte"




class NodeCollumnView extends CollumnView
  # class: "NodeColum:View",
  events: 
    "enter" : "clicked"


  initialize: ->
    #console.log "NodeCollumnView init", @collection
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

    # if id = @get("activeID")
    #   activeNode = @collection.get(id)
    #   console.log "activeNode", 
    
  clicked: (event, view) ->
    # console.log "col clicked"
    @open(view.model)
    return false;
  
  open: (model) ->
    #@close()
    if model.isEvent()
      view = new vvz.Event.EventView(parent: model)
    else
      collection = new vvz.Colum.Collection(model.get("children"))
      view = new vvz.Colum.View 
        collection: collection
    
    #vvz.columnManager.add(view)
    vvz.columnManager.addAfter(this, view)
    @setHistory(model)

  setHistory: (model) ->
    if history && history.replaceState
      history.replaceState({}, "", model.url())

  close: ->
    #console.log "close", @collection.activeModel
    vvz.columnManager.removeAfter(this)
  
  render: ->
    $(@el).empty()
    if @nodes.length > 0
      for view in @nodes
        $(@el).append(view.el)
    else
      $(@el).addClass("empty")
      $(@el).append("Keine Veranstaltungen vorhanden")

  remove: ->
    @collection.deactivateActive()
    super

vvz.Colum =
  Collection: Collection
  View: NodeCollumnView
  CollumnView: CollumnView

