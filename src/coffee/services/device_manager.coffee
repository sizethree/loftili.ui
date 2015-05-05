sDeviceManager = ($q, Analytics, Api, Socket, DEVICE_STATES) ->

  QueueManager = (device) ->

    Manager = {}

    Manager.add = (track) ->
      defer = $q.defer()

      success = (new_queue) ->
        defer.resolve new_queue.queue

      fail = () ->
        defer.reject()

      (Api.TrackQueue.add
        id: device.id
        track: track.id
      ).$promise.then success, fail

      defer.promise

    Manager


  DeviceManager = (device) ->
    is_connected = false

    playback = (evt) ->
      handler = () ->
        defer = $q.defer()

        success = () ->

        fail = () ->

        (Api.Playback[evt]
          device: device.id
        ).$promise.then success, fail

        defer.promise

    update = (data) ->
      console.log data

    Manager = {}

    Manager.connect = (callback) ->
      connected = (err) ->
        is_connected = !err
        stream_url = ['/devicestream', device.id].join '/'
        Socket.get stream_url
        Socket.on 'update', update
        callback err

      Socket.connect connected

    Manager.play = playback 'start'

    Manager.stop = playback 'stop'

    Manager.queue = QueueManager device

    Manager
    

  DeviceManager

sDeviceManager.$inject = [
  '$q'
  'Analytics'
  'Api'
  'Socket'
  'DEVICE_STATES'
]

lft.service 'DeviceManager', sDeviceManager
