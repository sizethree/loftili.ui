_factory = ($q, Analytics, Api, DEVICE_STATES, DeviceFeed) ->

  playbackFn = (type) ->
    deferred = $q.defer()

    finish = (result) =>
      @trigger type
      deferred.resolve result

    fail = (result) =>
      deferred.reject result

    request = Api.Playback[type]
      device: @device.id

    Analytics.event 'playback', type, ['device', @device.name].join(':')

    request.$promise.then finish, fail

    deferred.promise

  class DeviceManager

    constructor: (@device) ->
      @current_queue = null
      @last_ping = null
      @feed = new DeviceFeed @device
      @listeners =
        stop: []
        start: []
        restart: []

      update = (err, device) =>
        if device and device.ping
          @last_ping = device.ping

      @feed.add update, true

    on: (event, fn) ->
      is_function = angular.isFunction fn
      is_evtlist = angular.isArray @listeners[event]

      if is_function and is_evtlist
        @listeners[event].push fn

    trigger: (event) ->
      fn() for fn in @listeners[event]

    currentTrack: () ->
      has_queue = @current_queue and @current_queue.length > 0
      has_ping = @last_ping and @last_ping.track_id >= 0
      if has_ping and has_queue
        found_title = false
        track_id = @last_ping.track_id
        for track in @current_queue
          found_title = track.title if track_id == track.id
        found_title
      else
        return false

    removeQueueItem: (index) ->
      deferred = $q.defer()

      success = (new_queue) ->
        deferred.resolve new_queue

      fail = () ->
        deferred.reject()

      request = Api.TrackQueue.remove
        id: @device.id
        position: index

      request.$promise.then success, fail

      deferred.promise

    queueTrack: (track) ->
      deferred = $q.defer()

      success = (new_queue) ->
        deferred.resolve new_queue

      fail = () ->
        deferred.reject()

      request = Api.TrackQueue.add
        id: @device.id
        track: track.id

      request.$promise.then success, fail

      deferred.promise

    getQueue: () ->
      deferred = $q.defer()

      success = (result) =>
        @current_queue = result
        deferred.resolve result

      fail = (result) =>
        deferred.reject result

      request = Api.TrackQueue.query
        id: @device.id

      request.$promise.then success, fail

      deferred.promise

    ping: () ->
      deferred = $q.defer()

      success = (result) =>
        @last_ping = result
        deferred.resolve result

      fail = (result) =>
        deferred.reject result

      request = Api.Device.ping
        device_id: @device.id

      request.$promise.then success, fail

      deferred.promise

    restartPlayback: () ->
      playbackFn.call @, 'restart'

    stopPlayback: () ->
      playbackFn.call @, 'stop'

    startPlayback: () ->
      playbackFn.call @, 'start'

  DeviceManager

_factory.$inject = ['$q', 'Analytics', 'Api', 'DEVICE_STATES', 'DeviceFeed']

lft.service 'DeviceManager', _factory
