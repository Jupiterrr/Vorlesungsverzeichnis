
class VvzColumnView

  #template = HoganTemplates["vvz/templates/_event"]

  constructor: () ->
    @$el = $("#vvz")
    @$backBtn = $("#vvz-back-btn")
    @dataStore = new VvzDataStore()

    items = [] #@dataStore.getVvzs(root_ids)

    @$backBtn.attr("href", "javascript:;")
    @$backBtn.on("click", => @collumnView.back())
    @trackPageview = _.debounce(@_trackPageview, 3000)
    @setHistory = _.debounce(@_setHistory, 300)

    @collumnView = @initView()

    $(window).on("styleChange", (e, isMobile) => @collumnView.setLayout(@_layout()) )
    @$el.on("click", ".combined-date", => @collumnView._resize() )


  initView: () ->
    that = this
    new ColumnView @$el[0],
      source: @source
      path: @initialPath()
      onChange: @onChange
      itemTemplate: @itemTemplate
      layout: @_layout()
      ready: ->
        accordionyziseThis(that.el)
        that.$backBtn.toggleClass("hidden", !this.canMoveBack())

  initialPath: () ->
    path = window.current_path.slice(0)
    path.unshift(window.preload.rootID)
    #path = getNodes(window.current_path)
    if window.eventID
      # todo
      # event = @dataStore.getEventNodes(path.slice(-1), [window.eventID])[0]
      value = "#{path.slice(-1)}/#{window.eventID}"
      path.push(value)
    path

  itemTemplate: (data) ->
    "<a href=\"#{data.url}\" class=\"item\" data-value=\"#{data.value}\" role=\"treeitem\">#{data.name}</a>"

  source: (value, cb) =>
    # console.log "source", value
    path = @pathObj(value)
    if path.eventID
      @sourceEvent(path.nodeID, path.eventID).done(cb)
    else
      @sourceNode(path.nodeID).done(cb)

  onChange: (value) =>
    # console.log("change", value)
    @$backBtn.toggleClass("hidden", !@collumnView.canMoveBack())
    path = @pathObj(value)
    node = @dataStore.getNode(path.nodeID, path.eventID)
    @setHistory(node.name, node.url)
    accordionyziseThis(@el) if path.eventID

  _layout: () -> if isMobile() then "mobile" else "default"

  _setHistory: (title, url) ->
    if history && history.replaceState
      history.replaceState({}, title, url)
    $('title').text(title)
    @trackPageview(title, url)

  _trackPageview: (pageTitle, pageUrl) ->
    return unless _gaq?
    _gaq.push(["_set", "title", pageTitle])
    _gaq.push(['_trackPageview', pageUrl])

  pathObj: (value) ->
    path = value.split("/")
    {nodeID: path[0], eventID: path[1]}


  sourceEmpty: (node) ->
    div = document.createElement("div")
    div.classList.add("empty")
    div.innerHTML = "Keine Veranstaltungen vorhanden"
    {dom: div}

  asyncSourceLeaf: (node) ->
    @dataStore.asyncGetEventNodesByLeaf(node)
      .pipe(@dataStore.groupEventNodes)
      .pipe((groups)-> {groups: groups})

  sourceVvzNode: (node) ->
    nodes = @dataStore.getVvzs(node.childIDs)
    {items: nodes}

  sourceNode: (nodeID) =>
    defer = $.Deferred()
    node = @dataStore.getVvz(nodeID)
    childIDs = node.childIDs || []

    if node.isLeaf
      @asyncSourceLeaf(node).done(defer.resolve)
    else if childIDs.length == 0
      defer.resolve @sourceEmpty(node)
    else
      defer.resolve @sourceVvzNode(node)

    defer.promise()

  sourceEvent: (nodeID, eventID) ->
    @dataStore.asyncGetEvent(eventID).pipe (event) ->
      div = document.createElement("div")
      div.innerHTML = event.html
      {dom: div}




# todo
# * analytics

$ ->
  if ColumnView.canBrowserHandleThis()
    new VvzColumnView()
