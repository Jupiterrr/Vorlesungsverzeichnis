class PostForm

  constructor: (el) ->
    @$el = el
    @$textarea = el.find("textarea")
    @$submitBtn = @$el.find(".js-submit-btn")
    @$cancelBtn = @$el.find(".js-cancel-btn")

    @$el.on "click", @activate
    @$textarea.one "change", @activate

    @$submitBtn.on "click", @post
    @$textarea.on "input", @resizeTextarea
    @$textarea.on "input"
    @$cancelBtn.click @deactivate


  resizeTextarea: ->
    this.style.overflow = 'hidden'
    this.style.height = 0
    newHeight = this.scrollHeight + 15
    this.style.height = newHeight + 'px'

  activate: =>
    @$el.addClass("active")
    @$textarea.css("height", 43)

  deactivate: (e)=>
    console.log "__"
    @$el.removeClass("active")
    @$textarea.css("height", "")
    @$textarea.val("")
    e.stopPropagation()

  post: =>
    text = @$textarea.val()
    boardID = @$el.data("board-id")
    console.log("post", boardID, text, this)
    $.ajax
      type: "POST"
      url: "/posts"
      data: {
        "text": text,
        "board_id": boardID
      }
      success: (data) =>
        console.log("post ok", data)
        window.location.reload(true)
      error: (xhr, msg, trace) ->
        console.log "post error", xhr.status, xhr.statusText, msg, trace

deletePost = (id)->
  console.log("delete post", id)
  $.ajax
    type: "POST"
    url: "/posts/#{id}"
    data: {"_method":"delete"},
    success: (data) =>
      console.log("post deleted", data)
      window.location.reload(true)
    error: (xhr, msg, trace) ->
      console.log "post deletion error", xhr.status, xhr.statusText, msg, trace

$ ->
  form = $(".post-form")
  postForm = new PostForm(form)

  $(".js-post-delete-btn").click ->
    $(this).trigger("delete")

  $(".post").on "delete", ->
    id = $(this).data("id")
    deletePost(id)
