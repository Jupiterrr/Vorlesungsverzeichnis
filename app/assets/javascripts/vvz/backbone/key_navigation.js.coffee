class vvz.KeyNavigation

  constructor: (el) ->
    @el = el
    $(window).on("keydown", @handleKeyDown)

  keyCodes:
    enter: 13,
    space: 32,
    backspace: 8,
    tab: 9,

    pageup: 33,
    pagedown: 34,
    end: 35,
    home: 36,
    left: 37,
    up: 38,
    right: 39,
    down: 40,
    asterisk: 106,
    vimLeft: 72 # h
    vimRight: 76 #l
    vimUp: 75 #k
    vimDown: 74 #j

  handleKeyDown: (e)=>
    if $(":focus").is("input")
      return true

    if (e.keyCode != @keyCodes.tab) && (e.altKey || e.ctrlKey || e.shiftKey)
      # do nothing
      return true

    if @isNothingSelected() && @isArrowKey(e.keyCode)
      vvz.columnManager.cols[0].collection.first().activate()
      return false


    if e.shiftKey && e.keyCode == @keyCodes.tab
      @up(e)
      e.stopPropagation()
      return false

    switch e.keyCode
      when @keyCodes.up
        console.log "up"
        @up(e)
        e.stopPropagation()
        return false
      when @keyCodes.down, @keyCodes.tab
        console.log "down"
        @down(e)
        e.stopPropagation()
        return false
      when @keyCodes.left, @keyCodes.backspace
        # console.log "down"
        @left(e)
        e.stopPropagation()
        return false
      when @keyCodes.right, @keyCodes.space, @keyCodes.enter
        # console.log "down"
        @right(e)
        e.stopPropagation()
        return false

  down: (e)->
    $("a[role=treeitem].active").last().trigger("navDown")

  up: (e)->
    $("a[role=treeitem].active").last().trigger("navUp")

  right: (e) ->
    console.log "right"
    $("a[role=treeitem].active").last().trigger("navRight")

  left: (e) ->
    if vvz.columnManager.cols.length > 2
      actives = $("a[role=treeitem].active")
      lastActive = actives[actives.length-2]
      $(lastActive).focus()
      vvz.columnManager.back()

  isNothingSelected: ->
    $("a[role=treeitem].active").length == 0

  isArrowKey: (keyCode) ->
    keys = [@keyCodes.right, @keyCodes.left, @keyCodes.down, @keyCodes.up]
    _(keys).contains(keyCode)
