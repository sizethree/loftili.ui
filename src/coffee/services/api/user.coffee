dependencies = ['$resource', '$q', 'URLS', 'Api/Device', 'Api/Track', 'Api/Artist']
UserFactory = dependencies.concat [($resource, $q, URLS, Device, Track, Artist) ->

  user_defaults =
    user_id: '@id'

  User = $resource [URLS.api, 'users', ':user_id', ':fn'].join('/'), user_defaults,
    update:
      method: 'PUT'

    addTrack:
      method: 'PUT'
      params:
        fn: 'tracks'

    dropTrack:
      method: 'DELETE'
      url: [URLS.api, 'users', ':user', 'tracks', ':track'].join '/'

    search:
      method: 'GET'
      url: [URLS.api, 'users', 'search'].join '/'
      isArray: true

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
              parsed.push new Track raw_track
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

            full = Artist.get
              artist_id: artist_id

            full.$promise.then addOne, failedOne
            full

          getArtists = (tracks) ->
            for track, index in tracks
              if track.artist and (not artists[track.artist])
                artists[track.artist] = fetch track.artist
                artist_count++

            if artist_count == 0
              delegateArtists()

          if tracks.length > 0
            getArtists(tracks)
          else
            deferred.resolve parsed

          deferred.promise

    devices:
      method: 'GET'
      url: [URLS.api, 'devicepermissions'].join('/')
      isArray: true
      interceptor:
        response: (response) ->
          data = response.data
          devices = []

          parse = (mapping) ->
            device = new Device mapping.device
            device.permission = mapping.level
            device

          if angular.isArray data
            devices.push parse(mapping) for mapping in data

          devices

]

lft.service 'Api/User', UserFactory
