lft.service 'Api', ['$resource', '$q', 'API_HOME', ($resource, $q, API_HOME) ->

  Api = {}

  user_defaults =
    user_id: '@id'

  track_defaults =
    track_id: '@id'

  Api.User = $resource [API_HOME, 'users', ':user_id', ':fn'].join('/'), user_defaults,
    tracks:
      method: 'GET'
      params:
        fn: 'tracks'
      isArray: true
      interceptor:
        response: (response) ->
          if (not response.data) or (not angular.isArray response.data)
            deferred.reject()

          deferred = $q.defer()
          parsed = []
          tracks = response.data

          check = () ->
            if tracks.length == parsed.length
              deferred.resolve parsed

          fetch = (track, index) ->
            addOne = (track) ->
              parsed.splice index, 0, track
              check()

            failedOne = () ->
              deferred.reject()

            full = Api.Track.get
              track_id: track.id

            full.$promise.then addOne, failedOne

          fetch track, index for track, index in tracks

          deferred.promise
    devices:
      method: 'GET'
      params:
        fn: 'devices'
      isArray: true

  Api.Auth = $resource [API_HOME, 'auth'].join('/'), {},
    check:
      method: 'GET'
      interceptor:
        response: (response) ->
          return new Api.User(response.data)
    attempt:
      method: 'POST'
      interceptor:
        response: (response) ->
          return new Api.User(response.data)
    logout:
      method: 'GET'
      url: [API_HOME, 'logout'].join('/')

  Api.Device = $resource [API_HOME, 'devices', ':device_id'].join('/'), {}

  Api.Track = $resource [API_HOME, 'tracks', ':track_id'].join('/'), {},
    upload:
      method: 'POST'
      params:
        track_id: 'upload'
      transformRequest: (data) ->
        fdt = new FormData()
        fdt.append 'file', data.track_file
        fdt

  # must be returned
  Api

]
