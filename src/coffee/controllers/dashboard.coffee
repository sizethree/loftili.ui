lft.controller 'DashboardController', ['$scope', 'tracks', 'devices', ($scope, tracks, devices) ->

  $scope.tracks = tracks
  $scope.devices = devices

  $scope.newbie = true

  $scope.nonewb = () ->
    $scope.newbie = false

]
