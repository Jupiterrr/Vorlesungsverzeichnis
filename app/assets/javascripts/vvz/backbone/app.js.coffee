class AppView extends Backbone.View

  initialize: -> 
    @el = $("#vvz .overflow")
    @back_btn = $("#vvz .back")
    @build(current_path)

    setStyle = -> $("#vvz").toggleClass("mobile", isMobile())
    $(window).on("styleChange", setStyle)
    setStyle()

  build: (path) ->
    # clone, because the original path object should not change
    path = _.clone(path)
    console.log "path", path
    
    #existing_cols = @el.find(".spalte").toArray()
    @el.empty()
    @back_btn.attr("href", "javascript:;")
    cols = []
    
    isEventPage = !!window.eventID

    # console.error("Cols missing", path) if isEventPage && path.length + 1 > existing_cols.length
    # console.error("Cols missing", path) if path.length > 0

    # if isEventPage
    #   eventCol = existing_cols.pop()

    root = vvz.Node.Tree.getRoot() 
    cols.push @buildCol(root)

    parent = root
    for id in path
      model = parent.getChild(id)
      model.activate()
      console.error("Node does not exist!", {parent: parent, childID: id}) if !model
      cols.push @buildCol(model)
      parent = model

    if isEventPage
      model = parent.getChild(window.eventID)
      model.activate()
      cols.push new vvz.Event.EventView parent: model

    vvz.columnManager.seed(cols)
   
  
  buildCol: (model) ->
    collection = new vvz.Colum.Collection(model.get("children"))
    new vvz.Colum.View 
      collection: collection

  enterNode: (model) ->
    #children = model.get("children")
    new_view = new vvz.Colum.View parent: model
    vvz.columnManager.add(new_view)
    new_view
  
  enterEvent: (item) ->
    view = new vvz.Event.EventView model: item.model
    @addCol(view)


@vvz ||= {}

$ ->
  vvz.columnManager = new vvz.ColumnManagerClass( $("#vvz .overflow") )
  vvz.App = new AppView()
  
