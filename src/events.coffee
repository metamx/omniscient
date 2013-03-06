
###
retrieve relevant data then invoke all user-added handlers

@param event {Object} raw event
###

Stalker._uiHandler = (ev) ->
  el = Stalker._findFiringElement(ev.target)
  return if not el

  data = {
    context: Stalker._getContext(el)
    action: Stalker._findAction(el)
  }

  handler.call(el, data, ev) for handler in Stalker._handlers
  return

###
find the firing element based on the target

@param el {DOM Element} the target element of the event
@return {DOM Element} the determined firing element
@return false if not approperiate firing element available
###

Stalker._findFiringElement = (el) ->
  while el.parentNode
    return el if Stalker._validFiringElement(el)
    el = el.parentNode
  return false

###
whether the element is appropriate to be a firing element

@param el {DOM Element} the element in question
@return {Boolean} whether the element is a valid firing element
###

Stalker._validFiringElement = (el) ->
  validTag = el.tagName.toLowerCase() in Stalker._tags
  validDataTag = el.getAttribute('data-semantic-tag')?.toLowerCase() in Stalker._tags
  return validTag or validDataTag

###
find the action based on the target

@param el {DOM Element} the target element of the event
@return {String} the found action
###

Stalker._findAction = (el) ->
  return el.getAttribute('data-behavior') or el.innerText

###
determine the context of the event

@param el {DOM Element} the firing element
@return {Array} the determined context
@return false if the context is invalid
###

Stalker._getContext = (el) ->
  context = []
  while el.parentNode
    nodeContext = el.getAttribute('data-context')
    context.unshift(nodeContext) if nodeContext?
    el = el.parentNode
  if context.length is 0
    if Stalker._config.global
      context.unshift('global')
    else
      return false
  return context

###
invoke all handlers based on custom data

@param data {Object} event data user passed-in
###

Stalker._customHandler = (data) ->
  handler(data, null) for handler in Stalker._handlers
  return

###
manually submit a custom event

@param data {Object} JSON event data
###

Stalker.submit = (data) ->
  Stalker._customHandler(data)
  return