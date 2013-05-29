#= require twitter/bootstrap-typeahead
#= require underscore-min

$ ->
  el = $(".form-search")
  # search = new Search(el) if el.length > 0
  

class window.Search

  constructor: (el) ->
    @form = el
    @input = @form.find(".search-query")
    @url = @form.attr("action")
    type = @form.find("input[name=type]")
    @type = type.attr("value") || "all"

    console.log "init search",
      url: @url
      type: @type
      input: @input
    
    @query_cach = {}
    @object_map = {}

    fn = _.throttle(@source, 1000)
    @input.typeahead
      source: fn
      minLength: 2
      matcher: -> true
      highlighter: (id) => 
        item = @object_map[id]
        # console.log("item", item)
        if item.name.length < 100 
          name = item.name 
        else 
          index = item.name.indexOf(" ", 90)
          name = item.name.slice(0, index) + " …"
        """<b>#{name}</b><br><span class="type">#{item.type}</span>"""
      onselect: @onSelect

  source: (typeahead, query) =>
    console.log("query", query, typeahead)
    options =
      q: query
      type: @type
    if @query_cach[query]
      typeahead.process(@query_cach[query])
    else
      console.log("request", @query_cach, query in @query_cach, query)
      $.getJSON(@url, options, (data) => @onData(typeahead, data, query))
  
  onData: (typeahead, data, query) =>
    results = ("" + item.id for item in data)
    (@object_map["" + item.id] = item for item in data)
    if data.length == 0
      console.log("search", "not found")
    else
      console.log "result", data
    console.log "result", results
    @query_cach[query] = results
    typeahead.process(results)

  onSelect: (id) =>
    item = @cach[id]
    console.log("search:selected", id, item)
    window.location = item.url
  
  clear: () ->
    @el.val("")
  