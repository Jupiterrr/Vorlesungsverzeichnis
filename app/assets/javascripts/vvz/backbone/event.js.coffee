class Model extends vvz.Node.Model

  class: "Event:Model"

  urlRoot: "/events"

  initialize: ->
    # track request with google analytics

  url: ->
    "#{@urlRoot}/#{@id}"

  vvzPath: ->
    "/vvz/#{@get("parent").id}#{@url()}"

  subscribe: ->
    console.log("subscribe", this)
    $.ajax
      dataType: "json"
      url: "#{@url()}/subscribe"
      success: (data) =>
        console.log("sub ok", data)
        @set "subscribed": true
      error: @error

  unsubscribe: ->
    console.log("unsubscribe", this)
    $.ajax
      dataType: "json"
      url: "#{@url()}/unsubscribe"
      success: (data) =>
        console.log("unsub ok", data)
        @set "subscribed": false
      error: @error

  toggleSubscription: ->
    if @get("subscribed")
      @unsubscribe()
    else
      @subscribe()

  toJSON: ->
    data = Backbone.Model.prototype.toJSON.call(this);
    # data.loggedIn = !!currentUser
    data

  error: (d, e, x) =>
    console.log("error", d, e, x)


class EventView extends vvz.Colum.CollumnView

  class: "Event:EventView"

  events:
   "click #subscribe" : "subscribe"

  template: HoganTemplates["vvz/templates/_event"]

  initialize: ->
    #$(@el).addClass("event")

    @delegateEvents(@events)
    model = @options.parent.toJSON()

    @model = new Model(model)
    @model.fetch()
    @model.once('change', @render, this)
    @render
    @model.bind 'change:subscribed', (a,unsubscribed)->
      if !unsubscribed
        $("#subscribe i").attr("class", "fa-plus fa")
        $("#subscribe span").text("teilnehmen")
      else
        $("#subscribe i").attr("class", "fa-minus fa")
        $("#subscribe span").text("abmelden")

  render: ->
    # data = @model.toJSON()
    # html = @template.render(data)
    # $(@el).html(html)
    # $(@el).find('a[rel=tooltip]').tooltip()
    $(@el).html(@model.get("html"))
    accordionyziseThis($(@el))

  subscribe: ->
    $(@el).find("#subscribe i").attr("class", "fa-spinner fa-spin fa")
    @model.toggleSubscription()
    false


class NodeView extends vvz.Node.View

  class: "Event:NodeView"



vvz.Event =
  Model: Model
  #Collection: Collection
  EventView: EventView
  NodeView: NodeView

