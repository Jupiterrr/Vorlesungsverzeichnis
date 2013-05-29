class window.Poi

  constructor: (attributes) ->
    @attributes = attributes ? {}
    @ho = 5

  get : (key) -> @attributes[key];

  save: ->
    # console.log("save uiuiui")
    # $.ajax({
    #   type: 'POST',
    #   url: "/map/" + @poi.id,
    #   headers: {
    #     'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    #   },
    #   data: { 
    #     _method:'PUT', 
    #     poi : @poi 
    #   },
    #   success: () => {
    #     window.location.reload()
    #   }
    #   //dataType: dataType
    # });

class Singleton
  @instance = null
  @get: (obj)->
    @instance ?= new @(obj)

# =========
# = Modal =
# =========

class Modal extends Singleton

  constructor: (options) ->
    console.log("dsf", options)
    @el = options.el;
    @closeBtn = @el.find(".btn[data-dismiss=modal]")
    @el.modal(backdrop: true, show: false)

    # Events
    @closeBtn.on("click", => @el.modal("hide"))
    @el.on("show", => @suspendMainView)
    @el.on("hide", => @resumeMainView)

  suspendMainView: ->
    $(document.body).addClass("pause")

  resumeMainView: ->
    if @next
      window['keepBackdrop'] = true
      @next = false
    else
      window['keepBackdrop'] = false
      $(document.body).removeClass("pause")

  show: ->
    @el.modal("show")

  changeModal: (nextModal) ->
    @next = true
    @el.modal("hide")
    setTimeout (=> nextModal.show(poi)), 300

#  ================
#  = Select-Modal =
#  ================

class window.SelectView extends Modal

  constructor: ->    
    super
      el : $('#edit_modal')
    
    # search
    searchInput = @el.find('.search-query')
    @search = new MapSearch(searchInput) # for modal
    $(@search).on "select", (event, poiData) =>
      poi = new Poi(poiData)
      @openForm(poi)

    # dropdown
    dropdown = @el.find("select")
    dropdown.on "change", (event) =>
      poiID = $(event.target).val()
      poiData = pois[poiID]
      poi = new Poi(poiData)
      @openForm(poi)

    @el.on "show", => @clear()
    addBtn = @el.find("#add-poi-btn")
    addBtn.on "click", =>
      newPoi = new Poi()
      @openForm(newPoi)

  clear: ->
    @search.clear()
    setFocusFn = => @search.el.focus()
    setTimeout(setFocusFn, 500)

  openForm: (poi) ->
    console.log("edit poi", poi)
    @changeModal( new FormView(poi) )
    # @next = true
    # @el.modal("hide")
    # editView = new FormView()
    # setTimeout (=> editView.show(poi)), 300


#  ==============
#  = Edit-Modal =
#  ==============

class window.FormView extends Modal

  constructor: ->
    super 
      el: $("#edit_modal2")
    
    canvas = @el.find(".map")[0];
    @map = new google.maps.Map(canvas);
    @marker = new google.maps.Marker(map: @map, draggable: true);

    google.maps.event.addListener(@marker, 'dragend', => @onChange)
    @el.find("input[type=text]").on("keyup", => @onChange())
    @el.find(".save_btn").on("click", () => @save());
    @el.find("input[type=checkbox]").on("change", (e) => @onChange());

  show: (poi) ->
    @poi = poi;
    
    console.log("boom", poi)
    @el.modal("show");
    google.maps.event.trigger(@map, 'resize'); # http://stackoverflow.com/a/3782805/609868

    latlng = new google.maps.LatLng(poi.get('lat'), poi.get('lng'));
    @map.setOptions({
      zoom: 18,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.HYBRID
    });
    @marker.setPosition(latlng);
    @nameInput = @el.find("input[name=name]");
    @nameInput.val(poi.get('name'));

    group_ids = @poi.poi_group_ids;
    @el.find("input[type=checkbox]").each (i, checkbox) =>
      id = Number(checkbox.dataset.id);
      checkbox.checked = group_ids.indexOf(id) != -1;
  

  onChange: () ->
    # console.log("changed", @poi);
    # @poi.name = @nameInput.val()
    # position = @marker.getPosition()
    # @poi.lat = position.lat()
    # @poi.lng = position.lng()
    # group_ids = []
    # @el.find("input[type=checkbox]:checked").each (i, checkbox) =>
    #   group_ids.push(checkbox.dataset.id);

    # @poi.poi_group_ids = group_ids;

  save: ->
    console.log("save", @poi);
    @poi.save();

