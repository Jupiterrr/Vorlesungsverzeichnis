

// $(function(){
	
// 	var View = Backbone.View.extend({
		
// 		el: $("#search"),
//    	template: HoganTemplates["templates/_search.html"],
		
//     	events: {
//       	"keydown input"  : "navigate",
// 			"keyup input"  : "change",
// 			"click input" : "change"
//     	},
		
//     	initialize: function() {
// 			this.input = this.el.find("input");
// 			this.input.focus();
// 			var that = this;
// 			this.el.popover({
// 				offset: 0,
// 				placement: "below",
// 				content: function() {
// 					return " ";
// 				},
// 				trigger: "manual",
// 				html: true
// 			});
// 			this.el.popover('show');
// 			this.popover = $(".popover").hide();
// 			//this.isPopoverVisible = false;
	   	
// 			//this.model.bind('change', this.render, this);
// 			//this.delegateEvents(this.events);
			
// 			var mouse_is_inside = false;
// 			this.popover.hover(function(){ 
// 			       mouse_is_inside=true; 
// 			   }, function(){ 
// 			       mouse_is_inside=false; 
// 			});
				
// 			$("body").mouseup(function(){ 
// 				if(! mouse_is_inside) that.hide();
// 			});
// 	   },
		
// 		change: _.throttle(function(e) {
// 			this.show();
// 			switch(e.keyCode) {case 38: case 40: return false;};
			
// 			var value = this.input.val();
// 			if (value == "") return this.hide();
// 			if (value == this.lastValue) return;
// 			this.lastValue = value;
			
// 			var results = search(value);
// 			//console.log("search", value, results);
			
// 			//var items = [];
// 			//for(var i = 0; i < 10; i++) items.push(results[i]);
// 			this.render({items: results});
			
// 		}, 100),
		
// 		navigate: function(e) {
// 			//console.log("navigate", this.active);
			
// 			switch(e.keyCode) {
// 			case 40: //down
// 				this.down(); 
// 				return false;
// 			case 38: //up
// 				this.up();
// 				return false;
// 			}
// 		},
		
// 		up: function() {
// 			if (this.items.length == 0) return;
// 			if (this.active == 1) return;
			
// 			$(this.items).removeClass("active");
			
// 			this.active--;
// 			var item = this.items[this.active-1];
// 			$(item).addClass("active");
					
// 		},
// 		down: function() {
// 			if (this.items.length == 0) return;
// 			if (this.items.length <= this.active) return;
				
// 			$(this.items).removeClass("active");
         
// 			this.active++
// 			var item = this.items[this.active-1];
// 			$(item).addClass("active");
			
// 		},
		
// 		hide: function() {
// 			this.popover.hide();
// 		},
// 		show: function() {
// 			this.popover.show();
// 		},
// 		render: function(data) {
// 			var html = this.template.render(data);
// 			$(".popover .content").html(html);
// 			this.items = $(".popover .content a");
// 			this.active = 0;
// 		}
 	
// 	});
	
// 	window.Search = {
// 		View: new View
// 	};

// });

// function search(q) {
// 	var index = preload.index; //localStorage.getItem("index");
	
// 	var iss = [];

// 	var regex = new RegExp(q, 'i');
// 	var res;
	
// 	var parse = window.Node.Model.parse;
	
// 	var e, events = window.preload.events, l = events.length;
// 	while(l--) {
// 		e = events[l];
// 		if ( regex.exec(e[1]) ) iss.push( parse(e) );
// 	}
	
// 	var v, vvz = window.preload.vvz, l = vvz.length;
// 	while(l--) {
// 		v = vvz[l];
// 		if ( regex.exec(v[1]) ) iss.push( parse(v) );
// 	}
	
// 	return iss;
// }