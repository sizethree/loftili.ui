sQueueManager = ($q, Analytics, Api, Socket, DEVICE_STATES) ->

  QueueManager = (device) ->

    Manager = {}

    callbackId = do ->
      indx = 0
      () -> ['$', ++indx].join ''

    callbacks =
      'add': []
      'remove': []
      'refresh': []

    trigger = (evt, data) ->
      listeners = callbacks[evt]
      l.fn(data) for l in listeners

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
        trigger 'refresh', new_queue
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

  QueueManager

sQueueManager.$inject = [
  '$q'
  'Analytics'
  'Api'
  'Socket'
  'DEVICE_STATES'
]

lft.service 'QueueManager', sQueueManager
