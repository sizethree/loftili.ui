sSocket = (CONFIG) ->

  is_connected = false
  current_socket = null
  listeners = {}

  registerEvent = (evt) ->
    listeners[evt] = []

    runner = (args...) ->
      handler.fn.apply null, args for handler in listeners[evt]

    current_socket.on evt, runner

  uuid = do ->
    indx = 0
    () -> ['$', ++indx].join ''

  connect = (callback) ->
    is_connected = true

    current_socket = io CONFIG.socket.host,
      path: CONFIG.socket.path
      query:
        __sails_io_sdk_version: "0.11.0"
        __sails_io_platform: "browser"

    success = () ->
      callback null, true

    fail = (error) ->
      callback error, false

    current_socket.on 'connect', success
    current_socket.on 'error', fail

  Socket = {}

  Socket.on = (evt, fn) ->
    new_id = uuid true
    can_add = (angular.isFunction fn)
    registerEvent evt if !listeners[evt]

    listeners[evt].push
      id: new_id
      fn: fn

    new_id

  Socket.off = (lid) ->
    found = false

    checkEvt = (e) ->
      list = listeners[e]

      for a, i in list
        found = i if a.id == lid

      list.splice found, 1 if found != false
      true

    checkEvt evt for evt of listeners
    found
      
  Socket.emit = (evt, data) ->
    current_socket.emit evt, data if current_socket

  Socket.connect = (callback) ->
    connect.call @, callback unless is_connected

  Socket.get = (path) ->
    if current_socket
      (current_socket.emit 'get', {method: 'get', url: path})

  Socket

sSocket.$inject = ['CONFIG']

lft.service 'Socket', sSocket
