_factory = ($scope, Api, resolved) ->

  $scope.streams = resolved.streams
  $scope.devices = resolved.devices
  $scope.stream_permissions = resolved.stream_permissions
  $scope.active_nav = resolved.childView

_factory.$inject = [
  '$scope',
  'Api',
  'resolved',
]

lft.controller 'DashboardController', _factory
