lft.service 'Api', ['$resource', '$q', 'API_HOME', ($resource, $q, API_HOME) ->

  Api = {}

  user_defaults =
    user_id: '@id'

  track_defaults =
    track_id: '@id'

  device_defaults =
    device_id: '@id'

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
          artists = {}
          artist_count = 0
          tracks = response.data

          delegateArtists = () ->
            for raw_track in tracks
              raw_track.artist = artists[raw_track.artist]
              parsed.push new Api.Track raw_track
            deferred.resolve parsed

          check = () ->
            missing = false

            for id, artist of artists
              if artist.$resolved != true
                missing = true

            if !missing
              delegateArtists()
            else
              false

          fetch = (artist_id) ->
            addOne = (artist) ->
              check()

            failedOne = () ->
              deferred.reject()

            full = Api.Artist.get
              artist_id: artist_id

            full.$promise.then addOne, failedOne
            full

          getArtists = (tracks) ->
            for track, index in tracks
              if not artists[track.artist]
                artists[track.artist] = fetch track.artist
                artist_count++

          if tracks.length > 0
            getArtists(tracks)
          else
            deferred.resolve parsed

          deferred.promise
    devices:
      method: 'GET'
      url: [API_HOME, 'devicepermissions'].join('/')
      isArray: true
      interceptor:
        response: (response) ->
          data = response.data
          devices = []

          parse = (mapping) ->
            device = new Api.Device mapping.device
            device.permission = mapping.level
            device

          if angular.isArray data
            devices.push parse(mapping) for mapping in data

          devices

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

  Api.Device = $resource [API_HOME, 'devices', ':device_id', ':fn'].join('/'), device_defaults,
    delete:
      method: 'GET'
      params:
        fn: 'destroy'

  Api.DevicePermission = $resource [API_HOME, 'devicepermissions', ':permission_id'].join('/'), {},
    query:
      method: 'GET'
      isArray: true
      interceptor:
        response: (response) ->
          return response

  Api.Track = $resource [API_HOME, 'tracks', ':track_id'].join('/'), {},
    upload:
      method: 'POST'
      params:
        track_id: 'upload'
      transformRequest: (data) ->
        fdt = new FormData()
        fdt.append 'file', data.track_file
        fdt

  Api.Artist = $resource [API_HOME, 'artists', ':artist_id'].join('/'), {}

  # must be returned
  Api

]
