function MapSearch(el) {
  var that = this;
  this.el = el;
  var input = el;
  input.typeahead({
    // #name: 'countries'
    remote: {
      url: "/map/search?q=%QUERY&limit=10",
      filter: function(parsedResponse) {
         // console.log "filter", parsedResponse
        var result;
        var results = _.map(parsedResponse, function(poi) {
           result = {
            value: poi.name,
            tokens: [poi.name, poi.building_no],
            poi: poi,
            name: poi.name,
            building_no: poi.building_no
          }
          return result;
        });
        return results;
      }
    },
    limit: 7,
    template: [
      '<span class="repo-name">{{name}}</span> ',
      '<span class="poi-building_no">{{building_no}}</span>'
    ].join(''),
    engine: Hogan
  });

  input.on("typeahead:selected", function(e, value) {
    // console.log "selected", e, value
    $(that).trigger("select", value.poi);
  });
    
}
