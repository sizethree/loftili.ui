sDeviceManager = ($q, Analytics, Api, Socket, DEVICE_STATES) ->

  QueueManager = (device) ->

    Manager = {}

    callbackId = do ->
      indx = 0
      () -> ['$', ++indx].join ''

    callbacks =
      'add': []
      'remove': []

    trigger = (evt) ->
      listeners = callbacks[evt]
      l.fn() for l in listeners

    Manager.on = (evt, fn) ->
      is_valid = (angular.isArray callbacks[evt]) and (angular.isFunction fn)

      if is_valid
        callback_id = callbackId()
        callbacks[evt].push
          fn: fn
          id: callback_id
        callback_id
      else
        -1

    Manager.off = (id) ->
      for event of callbacks
        listeners = callbacks[event]
        for listener, index in listeners
          listeners.splice index, 1 if listener.id == id


    Manager.load = () ->
      defer = $q.defer()

      success = (new_queue) ->
        defer.resolve new_queue.queue

      fail = () ->
        defer.reject()

      (Api.TrackQueue.get
        id: device.id
      ).$promise.then success, fail

      defer.promise

    Manager.remove = (index) ->
      defer = $q.defer()

      success = () ->
        trigger 'remove'
        defer.resolve true

      fail = () ->
        defer.reject()

      (Api.TrackQueue.remove
        id: device.id
        position: index
      ).$promise.then success, fail

      defer.promise

    Manager.add = (track) ->
      defer = $q.defer()

      success = (new_queue) ->
        trigger 'add'
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
          defer.resolve true

        fail = () ->
          defer.reject false

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
