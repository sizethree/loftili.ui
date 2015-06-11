sStreamManager = ($q, Analytics, Api, Auth, Socket) ->

  levels =
    OWNER: 1
    CONTRIBUTOR: (1 << 1)

  StreamManager = (stream_id) ->
    manager =
      stream: null
      permissions: null
      owner: false
      contributor: false

    manager.update = (updates) ->
      deferred = $q.defer()

      params = angular.extend {id: stream_id}, updates

      success = () ->
        deferred.resolve true

      fail = () ->
        deferred.reject true

      (Api.Stream.update params).$promise.then success, fail

      deferred.promise

    manager.remove = (index) ->
      deferred = $q.defer()

      success = () ->
        deferred.resolve true

      fail = () ->
        deferred.reject false

      (Api.Stream.dequeue
        position: index
        id: stream_id).$promise.then success, fail

      deferred.promise

    manager.add = (track_id) ->
      deferred = $q.defer()

      success = () ->
        deferred.resolve true

      fail = () ->
        deferred.reject false

      (Api.Stream.enqueue
        id: stream_id
        track: track_id).$promise.then success, fail

      deferred.promise

    manager.refresh = () ->
      deferred = $q.defer()
      finished = 0
      required = 3

      loadedStream = (stream) ->
        manager.stream = stream
        deferred.resolve true if ++finished == required

      loadedPermissions = (permissions) ->
        manager.permissions = permissions
        user_id = Auth.user().id
        level = -1

        for p in permissions
          level = p.level if p.user.id == user_id

        manager.owner = level & levels.OWNER
        manager.contributor = level & (levels.OWNER | levels.CONTRIBUTOR)

        deferred.resolve true if ++finished == required

      loadedMappings = (mappings) ->
        manager.mappings = mappings
        deferred.resolve true if ++finished == required


      fail = () ->
        deferred.reject false

      (Api.Stream.get
        id: stream_id).$promise.then loadedStream, fail

      (Api.StreamPermission.query
        stream: stream_id).$promise.then loadedPermissions, fail

      (Api.DeviceStreamMapping.query
        stream: stream_id).$promise.then loadedMappings, fail

      deferred.promise

    manager

sStreamManager.$inject = [
  '$q'
  'Analytics'
  'Api'
  'Auth'
  'Socket'
]

lft.service 'StreamManager', sStreamManager
