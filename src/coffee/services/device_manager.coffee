lft.service 'DeviceManager', ['$q', 'Analytics', 'Api', ($q, Analytics, Api) ->

  class DeviceManager

    constructor: (@device) ->
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

    getState: () ->
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

]
