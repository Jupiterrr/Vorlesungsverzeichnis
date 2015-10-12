/*
 * classList.js: Cross-browser full element.classList implementation.
 * 2012-11-15
 *
 * By Eli Grey, http://eligrey.com
 * Public Domain.
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */

/*global self, document, DOMException */

/*! @source http://purl.eligrey.com/github/classList.js/blob/master/classList.js*/

if (typeof document !== "undefined" && !("classList" in document.documentElement)) {

(function (view) {

"use strict";

if (!('HTMLElement' in view) && !('Element' in view)) return;

var
    classListProp = "classList"
  , protoProp = "prototype"
  , elemCtrProto = (view.HTMLElement || view.Element)[protoProp]
  , objCtr = Object
  , strTrim = String[protoProp].trim || function () {
    return this.replace(/^\s+|\s+$/g, "");
  }
  , arrIndexOf = Array[protoProp].indexOf || function (item) {
    var
        i = 0
      , len = this.length
    ;
    for (; i < len; i++) {
      if (i in this && this[i] === item) {
        return i;
      }
    }
    return -1;
  }
  // Vendors: please allow content code to instantiate DOMExceptions
  , DOMEx = function (type, message) {
    this.name = type;
    this.code = DOMException[type];
    this.message = message;
  }
  , checkTokenAndGetIndex = function (classList, token) {
    if (token === "") {
      throw new DOMEx(
          "SYNTAX_ERR"
        , "An invalid or illegal string was specified"
      );
    }
    if (/\s/.test(token)) {
      throw new DOMEx(
          "INVALID_CHARACTER_ERR"
        , "String contains an invalid character"
      );
    }
    return arrIndexOf.call(classList, token);
  }
  , ClassList = function (elem) {
    var
        trimmedClasses = strTrim.call(elem.className)
      , classes = trimmedClasses ? trimmedClasses.split(/\s+/) : []
      , i = 0
      , len = classes.length
    ;
    for (; i < len; i++) {
      this.push(classes[i]);
    }
    this._updateClassName = function () {
      elem.className = this.toString();
    };
  }
  , classListProto = ClassList[protoProp] = []
  , classListGetter = function () {
    return new ClassList(this);
  }
;
// Most DOMException implementations don't allow calling DOMException's toString()
// on non-DOMExceptions. Error's toString() is sufficient here.
DOMEx[protoProp] = Error[protoProp];
classListProto.item = function (i) {
  return this[i] || null;
};
classListProto.contains = function (token) {
  token += "";
  return checkTokenAndGetIndex(this, token) !== -1;
};
classListProto.add = function () {
  var
      tokens = arguments
    , i = 0
    , l = tokens.length
    , token
    , updated = false
  ;
  do {
    token = tokens[i] + "";
    if (checkTokenAndGetIndex(this, token) === -1) {
      this.push(token);
      updated = true;
    }
  }
  while (++i < l);

  if (updated) {
    this._updateClassName();
  }
};
classListProto.remove = function () {
  var
      tokens = arguments
    , i = 0
    , l = tokens.length
    , token
    , updated = false
  ;
  do {
    token = tokens[i] + "";
    var index = checkTokenAndGetIndex(this, token);
    if (index !== -1) {
      this.splice(index, 1);
      updated = true;
    }
  }
  while (++i < l);

  if (updated) {
    this._updateClassName();
  }
};
classListProto.toggle = function (token, forse) {
  token += "";

  var
      result = this.contains(token)
    , method = result ?
      forse !== true && "remove"
    :
      forse !== false && "add"
  ;

  if (method) {
    this[method](token);
  }

  return !result;
};
classListProto.toString = function () {
  return this.join(" ");
};

if (objCtr.defineProperty) {
  var classListPropDesc = {
      get: classListGetter
    , enumerable: true
    , configurable: true
  };
  try {
    objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
  } catch (ex) { // IE 8 doesn't support enumerable:true
    if (ex.number === -0x7FF5EC54) {
      classListPropDesc.enumerable = false;
      objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
    }
  }
} else if (objCtr[protoProp].__defineGetter__) {
  elemCtrProto.__defineGetter__(classListProp, classListGetter);
}

}(self));

}
function debounce(func, wait, immediate) {
  var timeout, args, context, timestamp, result;

  function now() { new Date().getTime(); }

  var later = function() {
    var last = now() - timestamp;
    if (last < wait) {
      timeout = setTimeout(later, wait - last);
    } else {
      timeout = null;
      if (!immediate) {
        result = func.apply(context, args);
        context = args = null;
      }
    }
  };

  return function() {
    context = this;
    args = arguments;
    timestamp = now();
    var callNow = immediate && !timeout;
    if (!timeout) {
      timeout = setTimeout(later, wait);
    }
    if (callNow) {
      result = func.apply(context, args);
      context = args = null;
    }

    return result;
  };
}


var ColumnView = (function() {
  "use strict";

  var keyCodes, _slice, transformPrefix;

  keyCodes = {
    enter: 13,
    space: 32,
    backspace: 8,
    tab: 9,
    left: 37,
    up: 38,
    right: 39,
    down: 40,
  };

  _slice = Array.prototype.slice;

  transformPrefix = getTransformPrefix();

  function getTransformPrefix() {
    var el = document.createElement("_");
    var prefixes = ["transform", "webkitTransform", "MozTransform", "msTransform", "OTransform"];
    var prefix;
    while (prefix = prefixes.shift()) {
      if (prefix in el.style) return prefix;
    }
    console.warn("transform not supported");
    return null;
  }

  function uid() {
    return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
  }

  function ColumnView(el, options) {
    if (!ColumnView.canBrowserHandleThis()) {
      throw "This browser doesn't support all neccesary EcmaScript 5 Javascript methods.";
    }

    var that = this, onKeydown, onKeyup, resize;

    this.options = options || {};
    this.value = null;
    this.ready = false;
    this.carriageReady = false;

    this.el = el;
    this.domCarriage = this.el.querySelector(".carriage");
    this.carriage = document.createDocumentFragment();
    this.style = this.el.querySelector("style");

    this.models = options.items;
    this.path = options.path;
    this.movingUpOrDown = false;
    this.colCount = 3; //default

    this.callbacks = {
      change: that.options.onChange,
      source: that.options.source,
      ready:  that.options.ready
    };

    this.setLayout(options.layout);

    if (options.itemTemplate) {
      this.CustomSelect.prototype.itemTemplate = options.itemTemplate;
    }

    this.uniqueClassName = "column-view-" + uid();
    this.el.classList.add(this.uniqueClassName);
    this.el.setAttribute("tabindex", 0);
    this.el.setAttribute("role", "tree");

    // bound functions
    onKeydown = this._onKeydown.bind(this);
    onKeyup = this._onKeyup.bind(this);
    resize = debounce(this._resize.bind(this), 300);
    this._onColumnChangeBound = this._onColumnChange.bind(this);
    // onResize = _.bind(this._onResize, this);

    this.el.addEventListener("keydown", onKeydown, true);
    this.el.addEventListener("keyup", onKeyup, true);
    window.addEventListener("resize", resize);

    // todo prevent scroll when focused and arrow key is pressed
    // this.el.addEventListener("keydown", function(e){e.preventDefault();});

    this._initialize();
  }

  ColumnView.canBrowserHandleThis = function canBrowserHandleThis() {
    return !!Array.prototype.map &&
           !!Array.prototype.forEach &&
           !!Array.prototype.map &&
           !!Function.prototype.bind;
  };

  // instance methods
  // ----------------

  ColumnView.prototype = {

    // Getter
    // --------

    columns: function columns() {
      if (!this.carriageReady) throw "Carriage is not ready";
      return _slice.call( this.carriage.children );
    },

    focusedColumn: function focusedColumn() {
      var cols = this.columns();
      return cols[cols.length-2] || cols[0];
    },

    canMoveBack: function canMoveBack() {
      if (this.colCount === 3)
        return this.columns().length > 2;
      else
        return this.columns().length > 1;
    },


    // Keyboard
    // --------

    _onKeydown: function onKeydown(e) {
      this.movingUpOrDown = false;
      if (e.altKey || e.ctrlKey || e.shiftKey || e.metaKey)
        return; // do nothing

      switch (e.keyCode) {
        case keyCodes.left:
        case keyCodes.backspace:
          this._keyLeft();
          e.preventDefault();
          break;
        case keyCodes.right:
        case keyCodes.space:
        case keyCodes.enter:
          this._keyRight();
          e.preventDefault();
          break;
        case keyCodes.up:
          this.movingUpOrDown = true;
          this._moveCursor(-1);
          e.preventDefault();
          break;
        case keyCodes.down:
          this.movingUpOrDown = true;
          this._moveCursor(1);
          e.preventDefault();
          break;
        default:
          return;
      }
    },

    _onKeyup: function onKeyup() {
      this.movingUpOrDown = false;
      if (this.fastMoveChangeFn) this.fastMoveChangeFn();
    },

    _keyLeft: function keyLeft() { this.back(); },

    _keyRight: function keyRight() {
      var col = this.carriage.lastChild;
      if (col.customSelect) col.customSelect.selectIndex(0); // COL ACTION!!!!!!
      // triggers change
    },

    _moveCursor: function moveCursor(direction) {
      var col = this.focusedColumn();
      col.customSelect.movePosition(direction);
    },

    _onColumnChange: function onColumnChange(columnClass, value, oldValue) {
      var that = this;
      var column = columnClass.el;
      if (!this.ready) return;

      if (this.movingUpOrDown) {
        this.fastMoveChangeFn = function() { that._onColumnChange(columnClass, value, oldValue); };
        return;
      }

      this.fastMoveChangeFn = null;
      // console.log("cv change", value)

      this.value = value;

      if (this.focusedColumn() == column && this.columns().indexOf(column) !== 0) {
        this.lastColEl = this.carriage.lastChild;
      } else {
        this._removeAfter(column);
        this.lastColEl = null;
      }
      // console.log("horizontal change", this._activeCol == column)

      function appendIfValueIsSame(data) {
        if (that.value !== value) return;
        that._appendCol(data);
        that.callbacks.change.call(that, value);
      }

      this.callbacks.source(value, appendIfValueIsSame);

      // todo handle case case no callback is called
    },

    // Calls the source callback for each value in
    // this.path and append the new columns
    _initialize: function initialize() {
      var that = this;
      var path = this.path || [];
      console.log("path", path);
      var pathPairs = path.map(function(value, index, array) {
        return [value, array[index+1]];
      });
      this.carriage.innerHTML = "";

      function proccessPathPair(pathPair, cb) {
        var id = pathPair[0], nextID = pathPair[1];
        var customSelect;
        that.callbacks.source(String(id), function(data) {
          if (nextID) data.selectedValue = String(nextID);
          customSelect = that._appendCol(data);
          cb();
        });
      }

      function proccessPath() {
        var pathPair = pathPairs.shift();
        if (pathPair)
          proccessPathPair(pathPair, proccessPath);
        else
          ready();
      }

      function ready() {
        that.domCarriage.innerHTML = "";
        that.domCarriage.appendChild(that.carriage);
        that.carriage = that.domCarriage;
        that.carriageReady = true;
        that._resize();
        that._alignCols();
        that.ready = true;
        if (that.callbacks.ready) that.callbacks.ready.call(that);
      }

      proccessPath();
    },

    _appendCol: function appendCol(data) {
      var col = this._createCol(data);
      if (this.ready) this._alignCols();
      this.lastColEl = null;
      return col;
    },

    _createCol: function createCol(data) {
      var col;
      // use existing col if possible
      if (this.lastColEl) {
        col = this.lastColEl;
        col.innerHTML = "";
        // col.selectIndex = null;
        col.scrollTo(0, 0);
      } else {
        col = document.createElement("div");
        col.classList.add("column");
        this.carriage.appendChild(col);
      }
      return this._newColInstance(data, col);
    },

    _newColInstance: function newColInstance(data, col) {
      var colInst;
      if (col.customSelect) col.customSelect.clear();
      if (data.dom) {
        colInst = new this.Preview(col, data.dom);
        // reset monkeypatched properties for reused col elements
      }
      else if (data.items || data.groups) {
        data.onChange = this._onColumnChangeBound;
        colInst = new this.CustomSelect(col, data);
      }
      else {
        throw "Type error";
      }
      return colInst;
    },

    _removeAfter: function removeAfter(col) {
      var cols = this.columns();
      var toRemove = cols.splice(cols.indexOf(col)+1, cols.length);
      var that = this;
      toRemove.forEach(function(col) { that.carriage.removeChild(col); });
    },

    _alignCols: function alignCols() {
      var length = this.columns().length;
      if (this.lastAllignment === length)
        return; // skip if nothing has changed

      this.lastAllignment = length;
      var leftOut = Math.max(0, length - this.colCount);
      this.lastLeftOut = leftOut
      //this._moveCarriage(leftOut);
      this._resizeY();
    },

    _resize: function resize() {
      this.colWidth = this.el.offsetWidth / this.colCount;
      this._setStyle("width:"+this.colWidth+"px;");
      var col = this.columns().slice(-1)[0];
      var height = col.offsetHeight;
      this._setStyle("height:"+height+"px;"+"width:"+this.colWidth+"px;");
      this._moveCarriage(this.lastLeftOut, {transition: false});
    },

    _resizeY: function resize() {
      this.colWidth = this.el.offsetWidth / this.colCount;
      this._setStyle("width:"+this.colWidth+"px;");
      var col = this.columns().slice(-1)[0];
      var height = col.offsetHeight;
      this._setStyle("height:"+height+"px;"+"width:"+this.colWidth+"px;");
      this._moveCarriage(this.lastLeftOut);
    },

    _setStyle: function setStyle(css) {
      this.style.innerHTML = "."+this.uniqueClassName+" .column {"+css+"}";
    },

    setLayout: function setLayout(layout) {
      // console.log("setLayout", layout);
      if (layout == "mobile") {
        this.colCount = 1;
        this.el.classList.add("mobile");
      } else {
        this.colCount = 3;
        this.el.classList.remove("mobile");
      }
      if (!this.ready) return;
      this._resize();
    },

    _moveCarriage: function moveCarriage(leftOut, options) {
      options = options || {};
      if (!options.hasOwnProperty("transition")) options.transition = true
      this.lastLeftOut = leftOut;
      // console.log("move", this.ready)
      var left = -1 * leftOut * this.colWidth;
      this.carriage.classList.toggle("transition", this.ready && options.transition);
      this.carriage.style[transformPrefix] = "translate("+left+"px, 0px)";
    },

    // ### public

    back: function back() {
      if (!this.canMoveBack()) return;
      var lastCol = this.focusedColumn();
      this._removeAfter(lastCol);
      // triggers no change
      //if (lastCol.customSelect)
      lastCol.customSelect.deselect(); // COL ACTION!!!!!!

      this._alignCols();
      this.value = this.focusedColumn().customSelect.value();
      this.callbacks.change.call(this, this.value);
    }


  };

  return ColumnView;


})();


function htmlToDocumentFragment(html) {
  "use strict";
  var frag = document.createDocumentFragment();
  var tmp = document.createElement("body");
  tmp.innerHTML = html;
  var child;
  while (child = tmp.firstChild) {
    frag.appendChild(child);
  }
  return frag;
}


ColumnView.prototype.CustomSelect = (function() {
  "use strict";

  var indexOf = Array.prototype.indexOf;

  // aria-owns="catGroup" aria-expanded="false"
  // https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_group_role

  function CustomSelect(parent, data) {
    if (!data) data = {};

    this.el = parent;

    this.models = data.items;
    this.groups = data.groups;
    this.changeCB = data.onChange;

    this._selectedEl = this.el.querySelector(".selected");
    this.items = this.el.querySelectorAll(".item");

    this.value = null;

    this.el.setAttribute("role", "group");

    this.boundOnClick = this._onClick.bind(this);
    this.el.addEventListener("click", this.boundOnClick);

    this._monkeyPatchEl();

    if (this.models || this.groups) this._render(data.selectedValue);
  }

  // instance methods
  // ----------------

  CustomSelect.prototype = {

    _monkeyPatchEl: function monkeyPatchEl() {
      var that = this;
      var selectIndex = this.selectIndex.bind(this);
      var movePosition = this.movePosition.bind(this);
      var deselect = this.deselect.bind(this);
      var clear = this.clear.bind(this);
      var selectValue = this.selectValue.bind(this);
      var elMethods = {
        selectIndex: selectIndex,
        movePosition: movePosition,
        deselect: deselect,
        selectValue: selectValue,
        clear: clear,
        value : function value() { return that.value; }
      };
      this.el.customSelect = elMethods;
    },

    _render: function render(selectedValue) {
      var container = document.createDocumentFragment();

      if (this.groups) {
        this._renderGroups(container, this.groups);
      }
      else if (this.models) {
        this._renderItems(container, this.models);
      }
      else {
        this._renderEmpty(container);
      }

      this.el.innerHTML = "";
      this.el.appendChild(container);
      this.items = this.el.querySelectorAll(".item");
      if (selectedValue) this.selectValue(selectedValue);
    },

    _renderItems: function renderItems(container, models) {
      var that = this;
      models.forEach(function(model) {
        var html = that.itemTemplate(model);
        var item = htmlToDocumentFragment(html);
        container.appendChild(item);
      });
    },

    _renderGroups: function renderGroups(container, groups) {
      var that = this;
      groups.forEach(function(group) {
        var html = that.groupTemplate(group);
        var item = htmlToDocumentFragment(html);
        container.appendChild(item);
        that._renderItems(container, group.items);
      });
    },

    _renderEmpty: function renderEmpty(container) {
      var el = document.createTextNode("empty");
      container.appendChild(el);
    },

    clear: function clear() {
      this.el.customSelect = null;
      this.el.removeEventListener("click", this.boundOnClick);
    },

    _scrollIntoView: function scrollIntoView() {
      var elRect = this.el.getBoundingClientRect();
      var itemRect = this._selectedEl.getBoundingClientRect();

      if (itemRect.bottom > elRect.bottom) {
        this.el.scrollTop += itemRect.bottom - elRect.bottom;
      }

      if (itemRect.top < elRect.top) {
        this.el.scrollTop -= elRect.top - itemRect.top;
      }
    },

    _deselect: function deselect(el) {
      el.classList.remove("selected");
      this._selectedEl = null;
    },

    _select: function select(el) {
      if (this._selectedEl === el) return;

      if (this._selectedEl) this._deselect(this._selectedEl);
      el.classList.add("selected");
      this._selectedEl = el;
      var oldValue = this.value;
      this.value = el.getAttribute("data-value");
      this.changeCB(this, this.value, oldValue);
    },

    _onClick: function onClick(e) {
      if (e.ctrlKey || e.metaKey) return;
      if ( !e.target.classList.contains("item") ) return;
      e.preventDefault();
      this._select(e.target);
    },

    _getActiveIndex: function getActiveIndex() {
      var active = this._selectedEl;
      var index = indexOf.call(this.items, active);
      return index;
    },

    movePosition: function movePosition(direction) {
      var index = this._getActiveIndex();
      this.selectIndex(index+direction);
    },

    selectIndex:  function selectIndex(index) {
      var item = this.items[index];
      if (item) this._select(item);
      this._scrollIntoView();
    },

    // ### public

    remove: function remove() {
      this.el.remove();
    },

    deselect: function deselect() {
      if (this._selectedEl) this._deselect(this._selectedEl);
    },

    selectValue: function selectValue(value) {
      var el = this.el.querySelector("[data-value='"+value+"']");
      this._select(el);
    },

    itemTemplate: function itemTemplate(data) {
      return '<div class="item" data-value="'+data.value+'" role="treeitem">'+data.name+'</div>';
    },

    groupTemplate: function groupTemplate(data) {
      return '<div class="divider">'+data.title+'</div>';
    }

  };

  return CustomSelect;

})();


ColumnView.prototype.Preview = (function() {
  "use strict";

  function Preview(parent, el) {
    this.el = parent;
    this.el.appendChild(el);
    this.el.classList.add("html");
  }

  Preview.prototype = {
    remove: function remove() {
      this.el.remove();
    }
  };
  return Preview;
})();
