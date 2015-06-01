sDeviceManager = ($q, Analytics, EventManager, Api, Socket, QueueManager, DEVICE_STATES) ->

  DeviceManager = (device) ->
    is_connected = false

    playback = (evt) ->
      handler = () ->
        defer = $q.defer()

        success = () ->
          defer.resolve true

        fail = () ->
          defer.reject false

        (Api.Playback[evt]
          device: device.id
        ).$promise.then success, fail

        defer.promise

    events = EventManager ['update']

    update = (data) ->
      if /queue/i.test data
        Manager.queue.load()
      Manager.refresh()


    Manager =
      state: false
      play: playback 'start'
      stop: playback 'stop'
      skip: playback 'skip'
      queue: QueueManager device
      on: events.on
      off: events.off

    Manager.connect = (callback) ->
      connected = (err) ->
        is_connected = !err
        stream_url = ['/devicestream', device.id].join '/'
        Socket.get stream_url
        Socket.on 'update', update
        callback err
      Socket.connect connected

    Manager.refresh = () ->
      deferred = $q.defer()

      success = (data) ->
        Manager.state = data
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
  'QueueManager'
  'DEVICE_STATES'
]

lft.service 'DeviceManager', sDeviceManager
