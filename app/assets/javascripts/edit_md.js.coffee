$ ->
  form = $(".md-form-js")
  input = form.find(".md-input-js")
  writeBtn = form.find(".active.write-btn-js")
  previewBtn = form.find(".preview-btn-js")

  preview = null

  window.iiinput = input
  previewBtn.click ->
    text = input.val()
    $.post(
      "/events/preview_md",
      text: text,
      (data) -> switchToPreview(data)
    )

  writeBtn.click -> switchToWrite()

  switchToPreview = (html) ->
    input.hide()
    preview = $('<div class="markdown md-preview-js well md-preview"></div>')
    preview.append(html)
    preview.insertAfter(input)
    setActive(false)

  switchToWrite = ->
    preview.remove() if preview
    input.show()
    setActive(true)

  setActive = (isWriteActive) ->
    writeBtn.toggleClass("active", isWriteActive)
    previewBtn.toggleClass("active", !isWriteActive)
