dStreamTrackSearchItem = (Lang, Notifications) ->

  ADDING_LANG = Lang 'queuing.busy'
  LFTXS_RGX = /^lftxs$/i
  LF_RGX = /^lf$/i

  dStreamTrackSearchItemLink = ($scope, $element, $attrs) ->
    note_id = null

    $scope.add = () ->
      track = $scope.result
      note_id = Notifications.add ADDING_LANG, 'info'

      success = (new_queue) ->
        Notifications.remove note_id
        $scope.manager.refresh()

      fail = () ->
        Notifications.remove note_id
        failed_lang = Lang 'queuing.failed'
        Notifications.flash failed_lang, 'error'

      ($scope.manager.add
        id: track.id
        provider: track.provider
        pid: track.pid
      ).then success, fail

  lfStreamTrackSearch =
    replace: true
    templateUrl: 'directives.stream_track_search_item'
    scope:
      result: '='
      manager: '='
      artist: '&'
    link: dStreamTrackSearchItemLink

dStreamTrackSearchItem.$inject = [
  'Lang'
  'Notifications'
]


lft.directive 'lfStreamTrackSearchItem', dStreamTrackSearchItem
