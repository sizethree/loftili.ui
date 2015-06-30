sStreamManager = ($q, Analytics, Api, Auth, Socket) ->

  levels =
    OWNER: 1
    MANAGER: (1 << 1)
    CONTRIBUTOR: (1 << 1 << 1)

  StreamManager = (stream_id) ->
    manager =
      stream: null
      permissions: null
      owner: false
      contributor: false

    manager.move = (from, to) ->
      deferred = $q.defer()

      success = () ->
        deferred.resolve true

      fail = () ->
        deferred.reject true

      (Api.Stream.move
        id: stream_id
        from: from
        to: to).$promise.then success, fail

      deferred.promise

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

    manager.add = (track_details) ->
      deferred = $q.defer()

      success = () ->
        deferred.resolve true

      fail = () ->
        deferred.reject false

      (Api.Stream.enqueue
        id: stream_id
        track: track_details.id
        provider: track_details.provider
        pid: track_details.pid
      ).$promise.then success, fail

      deferred.promise

    manager.refresh = () ->
      deferred = $q.defer()
      finished = 0
      required = 3

      loadedStream = (stream) ->
        manager.stream = stream
        manager.artists = []
        artists = []

        if !stream.queue.length
          return deferred.resolve true if ++finished == required

        for track in stream.queue
          artist_id = track.artist
          existing = artists.indexOf artist_id
          if existing < 0 and artist_id > 0
            artists.push artist_id

        if artists.length == 0
          return deferred.resolve true if ++finished == required
       
        loadedArtist = (artist) ->
          manager.artists.push artist

          if manager.artists.length == artists.length
            deferred.resolve true if ++finished == required

        failArtist = () ->
          deferred.reject false

        (Api.Artist.get
          id: a).$promise.then loadedArtist, failArtist for a in artists

        true

      loadedPermissions = (permissions) ->
        manager.permissions = permissions
        user_id = Auth.user().id
        level = 0
        loaded_users = []

        loadedUser = (user) ->
          loaded_users.push user
          if loaded_users.length == permissions.length
            manager.users = loaded_users
            deferred.resolve true if ++finished == required

        failedUser = () ->
          deferred.reject false

        for p in permissions
          level = p.level if p.user == user_id
          (Api.User.get
            id: p.user).$promise.then loadedUser, failedUser

        manager.owner = level & levels.OWNER
        manager.contributor = level & (levels.OWNER | levels.CONTRIBUTOR)

        if permissions.length == 0
          deferred.resolve true if ++finished == required

        true

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
