_factory = ($q, Analytics, Api, DEVICE_STATES, DeviceFeed) ->

  class DeviceManager

    constructor: (@device) ->
      @feed = new DeviceFeed @device
      @listeners =
        stop: []
        start: []

    on: (event, fn) ->
      is_function = angular.isFunction fn
      is_evtlist = angular.isArray @listeners[event]

      if is_function and is_evtlist
        @listeners[event].push fn

    trigger: (event) ->
      fn() for fn in @listeners[event]

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
        deferred.resolve result

      fail = (result) =>
        deferred.reject result

      request = Api.Device.ping
        device_id: @device.id

      request.$promise.then success, fail

      deferred.promise

    stopPlayback: () ->
      deferred = $q.defer()

      finish = (result) =>
        @trigger 'stop'
        deferred.resolve result

      fail = (result) =>
        deferred.reject result

      request = Api.Playback.stop
        device: @device.id

      Analytics.event 'playback', 'stop', ['device', @device.name].join(':')

      request.$promise.then finish, fail

      deferred.promise

    startPlayback: () ->
      deferred = $q.defer()

      finish = (result) =>
        @trigger 'start'
        deferred.resolve result

      fail = (result) =>
        deferred.reject result

      request = Api.Playback.start
        device: @device.id

      Analytics.event 'playback', 'start', ['device', @device.name].join(':')

      request.$promise.then finish, fail

      deferred.promise

  DeviceManager

_factory.$inject = ['$q', 'Analytics', 'Api', 'DEVICE_STATES', 'DeviceFeed']

lft.service 'DeviceManager', _factory
