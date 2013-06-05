class vvz.ColumnManagerClass

  cols: []
  maxColCount: 3

  constructor: (el) ->
    @el = $(el)
    @back_btn = $("#vvz .back")
    @back_btn.click @back

    @styleChange(true)
    $(window).on("styleChange", => @styleChange())
    $(window).on("resize", @resize)


  styleChange: (first) =>
    # console.log "set styleChange"
    @maxColCount = if isMobile() then 1 else 3
    unless isMobile()
      $(".spalte").width('')

    #console.log "width", @width
    #@width = $(".spalte").width()+1;
    @width = $("#vvz").width() / @maxColCount;
    @reorder(true) unless first

  resize: (e,v) =>
    @width = $("#vvz").width() / @maxColCount;
    #console.log "resize width:", @width
    if isMobile()
      $(".spalte").width(@width)
      @reorder(true)

  addAfter: (source, colView) ->
    # console.log "add after"
    @removeAfter(source)
    @add(colView)
    if colView.class == "Event:EventView"
      @reorder(true)

  add: (colView, noReorder) ->
    # console.log "add"#, colView
    $(colView.el).width(@width) if isMobile()
    @push(colView)
    @reorder() unless noReorder

  pop: (_delay) ->
    col = @cols.pop()
    if _delay
      delay(200, -> col.remove())
    else
      col.remove()

  reorder: (force) ->
    console.log "reorder"
    i = @cols.length - @maxColCount
    speed = 0
    if i >= 0
      speed = if force then 0 else 250
      x = if isMobile() then 1 else 0

      # double shift for events
      if _(@cols).last().class == "Event:EventView"
        i += 1

      $(".overflow").transition({ x: "#{-i*(@width+x)}px" }, speed, "ease-out");
    delay 0, =>
      @back_btn.toggleClass("hidden", i <= 0)

      $(".spalte").removeClass("last")
      last = _.last(@cols)
      last.collection.deactivateActive() if last.collection
      $(last.el).addClass("last")

      i = 20
      set_height = ->
        height = $(last.el).height()
        # console.log "h", height, $(last.el)[0]
        if height > 0
          $("#vvz.mobile .box").height(height)
        else
          i -= 1
          if i > 0
            delay 100, -> set_height()
          else
            $("#vvz.mobile .box").height()

      delay 50, -> set_height()


  back: =>
    # console.log "back"
    @pop(true)
    @reorder()

  push: (colView) ->
    @el.append(colView.el)
    @cols.push(colView)

  removeAfter: (colView) ->
    # console.log "removeAfter"#, colView
    while _.last(@cols) != colView && @cols.length > 0
      @pop()

  seed: (colViews) ->
    for colView in colViews
      @add(colView, true)
    @reorder(true)

