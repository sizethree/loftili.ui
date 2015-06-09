_factory = ($scope, LibraryManager, resolved, Socket) ->

  $scope.streams = resolved.streams
  $scope.devices = resolved.devices

  $scope.newbie = true
  $scope.active_nav = resolved.childView

  $scope.nonewb = () ->
    $scope.newbie = false

_factory.$inject = [
  '$scope',
  'LibraryManager',
  'resolved',
  'Socket'
]

lft.controller 'DashboardController', _factory
