sDeviceManager = ($q, Analytics, EventManager, Api, Socket, StreamManager, DEVICE_STATES) ->

  DeviceManager = (device) ->
    is_connected = false
    socket_lid = null

    events = EventManager ['update']

    update = (data) ->
      Manager.refresh()

    Manager =
      state: false
      on: events.on
      off: events.off
      stream: null

    Manager.close = () ->
      Socket.off socket_lid

    Manager.connect = (callback) ->
      connected = (err) ->
        is_connected = !err
        stream_url = ['/devicestreams', device.id].join '/'
        Socket.get stream_url
        socket_lid = Socket.on 'update', update
        callback err
      Socket.connect connected

    Manager.subscribe = (id) ->
      deferred = $q.defer()

      success = (data) ->
        deferred.resolve true

      fail = () ->
        deferred.resolve false

      (Api.DeviceState.subscribe
        stream: id
        id: device.id).$promise.then success, fail

      deferred.promise

    Manager.refresh = () ->
      deferred = $q.defer()

      success = (data) ->
        Manager.state = data
        Manager.connected = /true/i.test data.connected

        if data.stream and (parseInt data.stream, 10) > 0
          stream_id = parseInt data.stream, 10
          Manager.stream = StreamManager stream_id
          Manager.stream.refresh()
        else
          Manager.stream = null

        deferred.resolve data
        events.trigger 'update'

      fail = () ->
        deferred.reject false

      (Api.DeviceState.get
        id: device.id).$promise.then success, fail

      deferred.promise

    Manager
    
  DeviceManager

sDeviceManager.$inject = [
  '$q'
  'Analytics'
  'EventManager'
  'Api'
  'Socket'
  'StreamManager'
  'DEVICE_STATES'
]

lft.service 'DeviceManager', sDeviceManager
