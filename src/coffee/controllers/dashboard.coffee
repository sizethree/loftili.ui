lft.controller 'DashboardController', ['$scope', 'tracks', 'devices', 'childView', ($scope, tracks, devices, childView) ->

  $scope.tracks = tracks
  $scope.devices = devices

  $scope.newbie = true
  $scope.active_nav = childView

  $scope.nonewb = () ->
    $scope.newbie = false

]
