
# Stalker global singleton
window.Stalker = Stalker = {}

# list of handlers added
Stalker._handlers = []

# list of tags to track
Stalker._tags = []

###
clear and re-track all elements with a data-behavior attribute

@param evType {Array} event types to track, defaults to ['click']
###

Stalker.init = ({ tags } = {}) ->
  Stalker._tags = tags?.toLowerCase() or ['a', 'button'] # lowercase the tags

  body = document.getElementsByTagName('body')[0]
  body.addEventListener('click', Stalker._uiHandler, true)
  return
