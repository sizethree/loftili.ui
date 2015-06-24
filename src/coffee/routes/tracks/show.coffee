rTracksRoute = ($routeProvider) ->

  resolution = ($q, $route, Auth, Api) ->
    deferred = $q.defer()
    resolved =
      track: null
      artist: null

    fail = () ->
      deferred.reject false

    success = (artist) ->
      resolved.artist = artist
      deferred.resolve resolved

    loadedTrack = (track) ->
      resolved.track = track

      if track.artist
        (Api.Artist.get
          id: track.artist).$promise.then success, fail
      else
        success null

    loadTrack = () ->
      current = $route.current.params
      id = parseInt current.id

      if id > 0
        (Api.Track.get
          id: id).$promise.then loadedTrack, fail
      else
        deferred.reject false

    (Auth.filter 'active').then loadTrack
    deferred.promise

  resolution.$inject = [
    '$q'
    '$route'
    'Auth'
    'Api'
  ]

  TrackRoute =
    templateUrl: 'views.track_management'
    controller: 'TrackManagementController'
    name: 'track_management'
    resolve:
      resolution: resolution

  $routeProvider.when '/tracks/:id', TrackRoute


rTracksRoute.$inject = [
  '$routeProvider'
]

lft.config rTracksRoute
