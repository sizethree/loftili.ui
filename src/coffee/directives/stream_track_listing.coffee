dStreamTrackListing = ($rootScope, $location, Lang, Api, Auth, Notifications) ->

  dStreamTrackListingLink = ($scope, $element, $attrs, $controller) ->
    moveItem = (from, to) ->
      success = () ->
        $scope.manager.refresh()
        $controller.clear()

      fail = () ->
        fail_lang = Lang 'stream.errors.moving'
        Notifications.flash.error fail_lang

      ($scope.manager.move from, to).then success, fail

    $controller.on 'change', moveItem

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
