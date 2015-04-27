sDeviceManager = ($q, Analytics, Api, Socket, DEVICE_STATES) ->

  DeviceManager = (device) ->
    is_connected = false

    playback = (evt, device) ->
      handler = () ->
        defer = $q.defer()
        defer.promise

    update = (data) ->
      console.log data

    Manager = {}

    Manager.connect = (callback) ->
      connected = (err) ->
        is_connected = !err
        Socket.get '/devicestream'
        Socket.on 'stuff', update
        callback err

      Socket.connect connected

    Manager.play = playback 'start', device

    Manager.stop = playback 'stop', device

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
