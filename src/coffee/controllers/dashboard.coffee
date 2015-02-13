_factory = ($scope, LibraryManager, activeUser, tracks, devices, childView, Socket) ->

  $scope.tracks = tracks
  $scope.devices = devices

  $scope.track_manager = new LibraryManager activeUser, tracks

  $scope.newbie = true
  $scope.active_nav = childView

  $scope.nonewb = () ->
    $scope.newbie = false

  Socket.connect true

_factory.$inject = [
  '$scope',
  'LibraryManager',
  'activeUser',
  'tracks',
  'devices',
  'childView',
  'Socket'
]

lft.controller 'DashboardController', _factory
