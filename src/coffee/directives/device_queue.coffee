dDeviceQueue = ($timeout, DEVICE_STATES, Notifications, Lang) ->

  dDeviceQueueLink = ($scope, $element, $attrs) ->
    $scope.adding = false
    $scope.searchToggle = () -> $scope.adding = !$scope.adding

  lfDeviceQueue =
    replace: true
    templateUrl: 'directives.device_queue'
    scope:
      manager: '='
      queue: '='
    link: dDeviceQueueLink


dDeviceQueue.$inject = [
  '$timeout'
  'DEVICE_STATES'
  'Notifications'
  'Lang'
]

lft.directive 'lfDeviceQueue', dDeviceQueue
