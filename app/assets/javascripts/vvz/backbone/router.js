$(function() {
	var Router = Backbone.Router.extend({

	  	routes: {
			"vvz": 				 "page",
	    	"vvz?a=:query":    "page"
	  	},

	  	page: function(x, y) {
			x = x || "root";
	   		console.log("location:", x);
	  	}

	});
	
	window.router = new Router;
	Backbone.history.start({pushState: true})
})