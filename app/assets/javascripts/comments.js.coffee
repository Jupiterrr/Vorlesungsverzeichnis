class CommentForm

  constructor: (el) ->
    @$el = $(el)
    @$textarea = @$el.find("textarea")

    @$textarea.on "keydown", (e) =>
      return if e.altKey || e.which != 13
      @postComment()
      return false;

    @$textarea.on "input", @resizeTextarea


  resizeTextarea: ->
    this.style.overflow = 'hidden'
    this.style.height = 0
    newHeight = this.scrollHeight
    this.style.height = newHeight + 'px'

  postComment: =>
    text = @$textarea.val()
    postID = @$el.data("post-id")
    console.log("post", postID, text, this)
    $.ajax
      type: "POST"
      url: "/comments"
      data:
        "text": text,
        "post_id": postID
      success: (data) =>
        console.log("comment ok", data)
        window.location.reload(true)
      error: (error) -> console.log "post error", error.status, error.statusText

deleteComment = (id)->
  console.log("delete comment", id)
  $.ajax
    type: "POST"
    url: "/comments/#{id}"
    data: {"_method":"delete"},
    success: (data) =>
      console.log("comment deleted", data)
      window.location.reload(true)
    error: (xhr, msg, trace) ->
      console.log "comment deletion error", xhr.status, xhr.statusText, msg, trace

$ ->
  forms = $(".comment-form")
  postForms = (new CommentForm(form) for form in forms)

  $(".js-comment-delete-btn").click ->
    $(this).trigger("deleteComment")

  $(".comment").on "deleteComment", ->
    id = $(this).data("id")
    deleteComment(id)

