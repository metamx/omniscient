
###
retrieve relevant data then invoke all user-added handlers

@param event {Object} raw event
###

Stalker._uiHandler = (ev) ->
  return if ev.target.tagName.toLowerCase() not in Stalker._tags

  target = ev.target

  data = {
    context: [],
    action: target.getAttribute('data-behavior') or target.innerText
  }

  seekNode = target
  while seekNode.tagName.toLowerCase() isnt 'body'
    context = seekNode.getAttribute('data-context')
    data.context.unshift(context) if context?
    seekNode = seekNode.parentNode
  if not data.context.length > 0
    return if not Stalker._config.global
    data.context = ['global']

  handler.call(target, data, ev) for handler in Stalker._handlers
  return

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