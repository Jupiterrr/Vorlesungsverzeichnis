class window.MapSearch

  constructor: (el) ->
    @el = el
    input = el
    input.typeahead
      #name: 'countries'
      remote:
        url: "/map/search?q=%QUERY&limit=10"
        filter: (parsedResponse)->
          # console.log "filter", parsedResponse
          for poi in parsedResponse
            value: poi.name
            tokens: [poi.name, poi.building_no]
            poi: poi
            name: poi.name
            building_no: poi.building_no
      limit: 7
      template: [
          '<p class="poi-building_no">{{building_no}}</p>'
          '<p class="repo-name">{{name}}</p>',
        ].join('')
      engine: Hogan

    input.on "typeahead:selected", (e, value) =>
      # console.log "selected", e, value
      $(this).trigger("select", value.poi)

