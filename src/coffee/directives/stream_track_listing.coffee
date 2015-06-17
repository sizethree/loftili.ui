dStreamTrackListing = ($rootScope, $location, Lang, Api, Auth, Notifications) ->

  dStreamTrackListingLink = ($scope, $element, $attrs, $controller) ->
    artist =
      name: ''

    moveItem = (from, to) ->
      success = () ->
        $scope.manager.refresh()
        $controller.clear()

      fail = () ->
        fail_lang = Lang 'stream.errors.moving'
        Notifications.flash.error fail_lang

      ($scope.manager.move from, to).then success, fail

    $controller.on 'change', moveItem

    $scope.artistFor = (track) ->
      artist_id = track.artist
      found = false

      for a in $scope.manager.artists
        found = a if a.id == artist_id

      found or artist

    $scope.remove = (index) ->
      success = () ->
        $scope.manager.refresh()

      fail = () ->
        lang = Lang 'streams.errors.removing_item'
        Notifications.flash.error lang

      ($scope.manager.remove index).then success, fail

  lfStreamTrackListing =
    replace: true
    templateUrl: 'directives.stream_track_listing'
    scope:
      manager: '='
    require: 'lfDraggableList'
    link: dStreamTrackListingLink

dStreamTrackListing.$inject = [
  '$rootScope'
  '$location'
  'Lang'
  'Api'
  'Auth'
  'Notifications'
]

lft.directive 'lfStreamTrackListing', dStreamTrackListing
