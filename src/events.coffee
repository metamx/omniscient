
###
retrieve relevant data then invoke all user-added handlers

@param event {Object} raw event
###

Omniscient._uiHandler = (ev) ->
  el = Omniscient._findFiringElement(ev.target)
  return if not el

  context = Omniscient._getContext(el)
  return unless context
  action = Omniscient._findAction(el)

  data = {
    context
    action
  }

  handler.call(el, data, ev) for handler in Omniscient._handlers
  return

###
find the firing element based on the target

@param el {DOM Element} the target element of the event
@return {DOM Element} the determined firing element
@return false if not approperiate firing element available
###

Omniscient._findFiringElement = (el) ->
  while el.parentNode
    return el if Omniscient._validFiringElement(el)
    el = el.parentNode
  return false

###
whether the element is appropriate to be a firing element

@param el {DOM Element} the element in question
@return {Boolean} whether the element is a valid firing element
###

Omniscient._validFiringElement = (el) ->
  validTag = el.tagName.toLowerCase() in Omniscient._tags
  validDataTag = el.getAttribute('data-semantic-tag')?.toLowerCase() in Omniscient._tags
  return validTag or validDataTag

###
find the action based on the target

@param el {DOM Element} the target element of the event
@return {String} the found action
###

Omniscient._findAction = (el) ->
  return el.getAttribute('data-behavior') or el.innerText

###
determine the context of the event

@param el {DOM Element} the firing element
@return {Array} the determined context
@return false if the context is invalid
###

Omniscient._getContext = (el) ->
  context = []
  while el.parentNode
    nodeContext = el.getAttribute('data-context')
    context.unshift(nodeContext) if nodeContext?
    el = el.parentNode
  if context.length is 0
    if Omniscient._config.global
      context.unshift('global')
    else
      return false
  return context

###
invoke all handlers based on custom data

@param data {Object} event data user passed-in
###

Omniscient._customHandler = (data) ->
  handler(data, null) for handler in Omniscient._handlers
  return

###
manually submit a custom event

@param data {Object} JSON event data
###

Omniscient.submit = (data) ->
  Omniscient._customHandler(data)
  return