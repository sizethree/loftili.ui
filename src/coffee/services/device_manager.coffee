sDeviceManager = ($q, $timeout, Analytics, EventManager, Api, Socket, StreamManager, UserCache, DEVICE_STATES) ->


  refreshFactory = (config) ->
    latest_refresh = 0
    current_bounce = null
    manager = config.manager
    device = config.device
    events = config.events

    run = () ->
      deferred = $q.defer()
      local_refresh = ++latest_refresh
      did_fail = false
      state = 0
      found_users = []
      user_ids = []

      receiveUser = (user_data) ->
        found_users.push user_data

        if found_users.length == user_ids.length and ++state == 2
          manager.users = found_users
          finish true

        false
      
      fail = () ->
        finish true if ++state == 2

      receivePermissions = (data) ->
        manager.permissions = data.resource

        user_ids = (p.user for p in manager.permissions)

        for id in user_ids
          (UserCache id).then receiveUser, fail

        true

      finish = () ->
        deferred.resolve local_refresh

      receiveState = (data) ->
        manager.state = data
        manager.state.playback = parseInt data.playback, 10 if data

        manager.connected = /true/i.test data.connected

        if data.stream and (parseInt data.stream, 10) > 0
          stream_id = parseInt data.stream, 10
          manager.stream = StreamManager stream_id
          manager.stream.refresh()
        else
          manager.stream = null

        if ++state == 2 then finish true else false
        

      failState = () ->
        return false if local_refresh != latest_refresh
        manager.state = false
        if ++state == 2 then finish true else false


      failPermissions = () ->
        if ++state == 2 then finish true else false

      (Api.DeviceState.get
        id: device.id).$promise.then receiveState, failState

      (Api.DevicePermission.query
        device: device.id).$promise.then receivePermissions, failPermissions

      deferred.promise

    refresh = () ->
      current_bounce = $q.defer() if !current_bounce

      finish = (run_id) ->
        bounced = () ->
          return true if run_id != latest_refresh
          events.trigger 'update'
          current_bounce.resolve true

        $timeout bounced, 300

      fail = () ->
        true

      (run 1).then finish, fail

      current_bounce.$promise

    refresh

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

    Manager.refresh = refreshFactory
      manager: Manager
      device: device
      events: events

    Manager
    
  DeviceManager

sDeviceManager.$inject = [
  '$q'
  '$timeout'
  'Analytics'
  'EventManager'
  'Api'
  'Socket'
  'StreamManager'
  'UserCache'
  'DEVICE_STATES'
]

lft.service 'DeviceManager', sDeviceManager
