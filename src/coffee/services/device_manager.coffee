sDeviceManager = ($q, Analytics, EventManager, Api, Socket, StreamManager, DEVICE_STATES) ->

  DeviceManager = (device) ->
    is_connected = false
    socket_lid = null
    latest_refresh = 0

    events = EventManager ['update']

    update = (data) ->
      Manager.refresh()

    Manager =
      state: false
      on: events.on
      off: events.off
      stream: null
      permissions: []
      users: []

    Manager.close = () ->
      Socket.off socket_lid

    Manager.connect = (callback) ->
      connected = (err) ->
        is_connected = !err
        stream_url = ['/sockets', 'devices', device.id].join '/'
        Socket.get stream_url
        socket_lid = Socket.on 'update', update
        callback err
      Socket.connect connected

    Manager.playback = (state) ->
      deferred = $q.defer()

      success = () ->
        deferred.resolve true

      fail = () ->
        deferred.resolve false

      (Api.DeviceState.playback
        id: device.id
        playback: state).$promise.then success,  fail

      deferred.promise

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
      local_refresh = ++latest_refresh
      did_fail = false
      state = 0

      receivePermissions = (data) ->
        return false if local_refresh != latest_refresh
        Manager.permissions = data.resource
        user_ids = (p.user for p in Manager.permissions)
        users = []

        receive = (user_data) ->
          users.push user_data
          if users.length == user_ids.length and ++state == 2
            Manager.users = users
            finish true
          else
            false
        
        fail = () ->
          finish true if ++state == 2

        (Api.User.get {id: id}).$promise.then receive, fail for id in user_ids

        true

      finish = () ->
        console.log 'finishing'
        deferred.resolve true
        events.trigger 'update'

      receiveState = (data) ->
        return false if local_refresh != latest_refresh

        latest_refresh = 0

        Manager.state = data
        Manager.state.playback = parseInt data.playback, 10 if data

        Manager.connected = /true/i.test data.connected

        if data.stream and (parseInt data.stream, 10) > 0
          stream_id = parseInt data.stream, 10
          Manager.stream = StreamManager stream_id
          Manager.stream.refresh()
        else
          Manager.stream = null

        if ++state == 2 then finish true else false
        

      failState = () ->
        return false if local_refresh != latest_refresh
        Manager.state = false
        if ++state == 2 then finish true else false


      failPermissions = () ->
        if ++state == 2 then finish true else false

      (Api.DeviceState.get
        id: device.id).$promise.then receiveState, failState

      (Api.DevicePermission.query
        device: device.id).$promise.then receivePermissions, failPermissions

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
