
# Omniscient global singleton
window.Omniscient = Omniscient = {}

# Config
Omniscient._config = {}

# list of handlers added
Omniscient._handlers = []

# list of tags to track
Omniscient._tags = []

###
clear and re-track all elements with a data-behavior attribute

@param evType {Array} event types to track, defaults to ['click']
###

Omniscient.init = ({ tags, global } = {}) ->
  Omniscient._tags = tags?.toLowerCase() or ['a', 'button'] # lowercase the tags
  Omniscient._config.global = global? or false

  body = document.getElementsByTagName('body')[0]
  body.addEventListener('click', Omniscient._uiHandler, true)
  return
