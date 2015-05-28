sDeviceManager = ($q, Analytics, Api, Socket, QueueManager, DEVICE_STATES) ->

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

    Manager =
      state: false
      play: playback 'start'
      stop: playback 'stop'

    Manager.connect = (callback) ->
      connected = (err) ->
        is_connected = !err
        stream_url = ['/devicestream', device.id].join '/'
        Socket.get stream_url
        Socket.on 'update', Manager.refresh
        callback err
      Socket.connect connected

    Manager.refresh = () ->
      deferred = $q.defer()

      success = (data) ->
        Manager.state = data
        deferred.resolve data

      fail = () ->
        deferred.reject false

      (Api.DeviceState.get
        id: device.id).$promise.then success, fail

      deferred.promise

    Manager.queue = QueueManager device

    Manager
    
  DeviceManager

sDeviceManager.$inject = [
  '$q'
  'Analytics'
  'Api'
  'Socket'
  'QueueManager'
  'DEVICE_STATES'
]

lft.service 'DeviceManager', sDeviceManager
