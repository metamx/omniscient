(function() {
  var Stalker;

  window.Stalker = Stalker = {};

  Stalker._config = {};

  Stalker._handlers = [];

  Stalker._tags = [];

  /*
  clear and re-track all elements with a data-behavior attribute
  
  @param evType {Array} event types to track, defaults to ['click']
  */


  Stalker.init = function(_arg) {
    var body, global, tags, _ref;
    _ref = _arg != null ? _arg : {}, tags = _ref.tags, global = _ref.global;
    Stalker._tags = (tags != null ? tags.toLowerCase() : void 0) || ['a', 'button'];
    Stalker._config.global = (global != null) || false;
    body = document.getElementsByTagName('body')[0];
    body.addEventListener('click', Stalker._uiHandler, true);
  };

}).call(this);


/*
retrieve relevant data then invoke all user-added handlers

@param event {Object} raw event
*/


(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  Stalker._uiHandler = function(ev) {
    var data, el, handler, _i, _len, _ref;
    el = Stalker._findFiringElement(ev.target);
    if (!el) {
      return;
    }
    data = {
      context: Stalker._getContext(el),
      action: Stalker._findAction(el)
    };
    _ref = Stalker._handlers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      handler = _ref[_i];
      handler.call(el, data, ev);
    }
  };

  /*
  find the firing element based on the target
  
  @param el {DOM Element} the target element of the event
  @return {DOM Element} the determined firing element
  @return false if not approperiate firing element available
  */


  Stalker._findFiringElement = function(el) {
    while (el.parentNode) {
      if (Stalker._validFiringElement(el)) {
        return el;
      }
      el = el.parentNode;
    }
    return false;
  };

  /*
  whether the element is appropriate to be a firing element
  
  @param el {DOM Element} the element in question
  @return {Boolean} whether the element is a valid firing element
  */


  Stalker._validFiringElement = function(el) {
    var validDataTag, validTag, _ref, _ref1, _ref2;
    validTag = (_ref = el.tagName.toLowerCase(), __indexOf.call(Stalker._tags, _ref) >= 0);
    validDataTag = (_ref1 = (_ref2 = el.getAttribute('data-semantic-tag')) != null ? _ref2.toLowerCase() : void 0, __indexOf.call(Stalker._tags, _ref1) >= 0);
    return validTag || validDataTag;
  };

  /*
  find the action based on the target
  
  @param el {DOM Element} the target element of the event
  @return {String} the found action
  */


  Stalker._findAction = function(el) {
    return el.getAttribute('data-behavior') || el.innerText;
  };

  /*
  determine the context of the event
  
  @param el {DOM Element} the firing element
  @return {Array} the determined context
  @return false if the context is invalid
  */


  Stalker._getContext = function(el) {
    var context, nodeContext;
    context = [];
    while (el.parentNode) {
      nodeContext = el.getAttribute('data-context');
      if (nodeContext != null) {
        context.unshift(nodeContext);
      }
      el = el.parentNode;
    }
    if (context.length === 0) {
      if (Stalker._config.global) {
        context.unshift('global');
      } else {
        return false;
      }
    }
    return context;
  };

  /*
  invoke all handlers based on custom data
  
  @param data {Object} event data user passed-in
  */


  Stalker._customHandler = function(data) {
    var handler, _i, _len, _ref;
    _ref = Stalker._handlers;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      handler = _ref[_i];
      handler(data, null);
    }
  };

  /*
  manually submit a custom event
  
  @param data {Object} JSON event data
  */


  Stalker.submit = function(data) {
    Stalker._customHandler(data);
  };

}).call(this);


/*
add event handler

@param handler {Function} function to execute whenever an event is received
  @param data {Object} event data
  @param ev {Object} raw event
  @this {Object} the firing element
*/


(function() {

  Stalker.addHandler = function(handler) {
    Stalker._handlers.push(handler);
  };

}).call(this);
