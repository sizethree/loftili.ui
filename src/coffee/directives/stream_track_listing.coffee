dStreamTrackListing = ($rootScope, $location, Lang, Api, Auth, Notifications) ->

  dStreamTrackListingLink = ($scope, $element, $attrs) ->
    artist =
      name: ''

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
