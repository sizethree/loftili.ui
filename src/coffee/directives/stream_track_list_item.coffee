dStreamTrackListItem = () ->

  dStreamTrackListItemLink = ($scope, $element, $attrs) ->
    removing_note = null

    $scope.artistFor = (track) ->
      artist_id = track.artist
      found = false

      for a in $scope.manager.artists
        found = a if a.id == artist_id

      found or null

    $scope.remove = () ->
      my_index = $scope.index

      success = () ->
        $scope.manager.refresh()

      fail = () ->
        lang = Lang 'streams.errors.removing_item'
        Notifications.flash.error lang

      ($scope.manager.remove my_index).then success, fail

  lfStreamTrackListItem =
    replace: true
    templateUrl: 'directives.stream_track_list_item'
    scope:
      index: '='
      manager: '='
      track: '='
    link: dStreamTrackListItemLink

dStreamTrackListItem.$inject = [
]

lft.directive 'lfStreamTrackListItem', dStreamTrackListItem
