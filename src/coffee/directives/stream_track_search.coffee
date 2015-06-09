dStreamTrackSearch = ($timeout, Api, Notifications, Lang) ->

  DEBOUNCE_TIME = 400

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

    display = (search_id) ->
      (results) ->
        if search_id == last_id
          $scope.results = results

    run = () ->
      last_id = idGen()

      $scope.results = null

      if last_val != ''
        track_promise = Api.Track.search
          q: last_val
        track_promise.$promise.then display(last_id)

    $scope.add = (track) ->
      success = (new_queue) ->
        $scope.manager.refresh()

      fail = () ->
        failed_lang = Lang 'queuing.failed'
        Notifications.flash failed_lang, 'error'

      ($scope.manager.add track.id).then success, fail

    $scope.keyUp = (event) ->
      last_val = event.target.value
      if timeout_id
        $timeout.cancel timeout_id
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
