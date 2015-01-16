_factory = ($scope, LibraryManager, activeUser, tracks, devices, childView) ->

  $scope.tracks = tracks
  $scope.devices = devices

  $scope.track_manager = new LibraryManager activeUser, tracks

  $scope.newbie = true
  $scope.active_nav = childView

  $scope.nonewb = () ->
    $scope.newbie = false

_factory.$inject = ['$scope', 'LibraryManager', 'activeUser', 'tracks', 'devices', 'childView']

lft.controller 'DashboardController', _factory
