dStreamTrackSearch = ($timeout, Api, Notifications, Lang) ->

  SEARCHING_LANG = Lang 'queuing.searcing'
  ADDING_LANG = Lang 'queuing.busy'
  DEBOUNCE_TIME = 400
  LFTXS_RGX = /^lftxs$/i
  LF_RGX = /^lf$/i

  idGen = do ->
    index = 0
    () ->
      index++
      index = 0 if index > 100
      index

  dStreamTrackSearchLink = ($scope, $element, $attrs) ->
    timeout_id = null
    last_val = null
    last_id = null
    $scope.results = null
    blank_artist = {name: ''}
    search_note = false

    $scope.clear = () ->
      $scope.results = null
      $scope.search.query = null

    $scope.artistFor = (track) ->
      artist_id = track.artist
      found = false

      if LFTXS_RGX.test track.provider
        return track.artist

      for a in $scope.artists
        found = a if a.id == artist_id

      found or blank_artist

    display = (search_id) ->
      tracks = null
      artist_ids = []
      artists = []
      attempted = 0

      finish = () ->
        is_latest = search_id == last_id
        $scope.artists = artists
        $scope.results = tracks if search_id == last_id
        Notifications.remove search_note if search_id == last_id
        true

      loadedArtist = (artist) ->
        artists.push artist
        finish true if ++attempted == artist_ids.length
        true

      failed = () ->
        finish true if ++attempted == artist_ids.length
        true

      (r) ->
        tracks = r

        for t in tracks
          artist_ids.push t.artist if LF_RGX.test t.provider

        return finish true if (artist_ids.length == 0 and search_id == last_id)

        for a in artist_ids
          (Api.Artist.get {id: a}).$promise.then loadedArtist, failed

        true

    run = () ->
      last_id = idGen()

      $scope.results = null

      display_fn = display last_id

      if last_val != '' and last_val.length > 3
        (Api.Track.search
          q: last_val).$promise.then display_fn
      else
        $scope.results = null

      true

    $scope.add = (track) ->
      note_id = Notifications.add ADDING_LANG, 'info'
      $scope.is_busy = true

      success = (new_queue) ->
        $scope.is_busy = false
        Notifications.remove note_id
        $scope.manager.refresh()

      fail = () ->
        $scope.is_busy = false
        Notifications.remove note_id
        failed_lang = Lang 'queuing.failed'
        Notifications.flash failed_lang, 'error'

      ($scope.manager.add
        id: track.id
        provider: track.provider
        pid: track.pid
      ).then success, fail

    $scope.update = () ->
      $timeout.cancel timeout_id if timeout_id

      if $scope.search.query == ''
        last_id = null
        $scope.results = []
        return false

      search_note = Notifications.add SEARCHING_LANG, 'info' if !search_note
      last_val = $scope.search.query
      timeout_id = $timeout run, DEBOUNCE_TIME

  lfStreamTrackSearch =
    replace: true
    templateUrl: 'directives.stream_track_search'
    scope:
      manager: '='
      queue: '='
    link: dStreamTrackSearchLink

dStreamTrackSearch.$inject = [
  '$timeout'
  'Api'
  'Notifications'
  'Lang'
]

lft.directive 'lfStreamTrackSearch', dStreamTrackSearch
