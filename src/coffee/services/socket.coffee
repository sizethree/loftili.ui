_factory = (CONFIG) ->

  is_connected = false
  current_socket = null

  connected = () ->

  connect = () ->
    is_connected = true
    current_socket = io CONFIG.urls.api,
      path: '/sock'

  Socket =

    connect: () ->
      connect.call @ unless is_connected

_factory.$inject = ['CONFIG']

lft.service 'Socket', _factory
