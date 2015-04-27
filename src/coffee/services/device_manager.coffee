sDeviceManager = ($q, Analytics, Api, Socket, DEVICE_STATES) ->

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
