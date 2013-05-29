$ ->
  input = $("#vvz_search .typeahead")
  term = input.data("term")
  input.typeahead
    name: 'countries'
    remote: "/search.json?type=vvz&term=#{term}&q=%QUERY&limit=10"
    template: [                                                                 
      '<p class="value">{{value}}</p>',                                      
      '<p class="description">{{description}}</p>'                         
    ].join('')
    limit: 7                                                               
    engine: Hogan

  input.on "typeahead:selected", (e, value) ->
    window.location = value.key

  current = false
  input.on "typeahead:autocompleted", (e, value) ->
    current = value.key

  input.on "change", (e) ->
    current = false

  input.keypress (e) ->
    if e.which == 13
      if current
        window.location = current
      else
        $("#vvz_search").submit()
