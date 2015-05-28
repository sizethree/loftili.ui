dDeviceQueue = (Notifications, Lang) ->

  dDeviceQueueLink = ($scope, $element, $attrs) ->
    $scope.adding = false
    listeners = []

    $scope.searchToggle = () ->
      $scope.adding = !$scope.adding

    $scope.removeItem = (index) ->
      success = () ->
        $scope.queue.splice index, 1

      fail = () ->
        fail_lang = Lang 'queuing.failed_remove'
        Notifications.flash.error fail_lang

      ($scope.manager.queue.remove index).then success, fail

    refreshed = (data) ->
      $scope.queue = data.queue

    listeners.push $scope.manager.queue.on 'add', () -> $scope.adding = false
    listeners.push $scope.manager.queue.on 'refresh', refreshed

    $scope.$on '$destroy', () -> $scope.manager.queue.off l for l in listeners

  lfDeviceQueue =
    replace: true
    templateUrl: 'directives.device_queue'
    scope:
      manager: '='
      queue: '='
    link: dDeviceQueueLink


dDeviceQueue.$inject = [
  'Notifications'
  'Lang'
]

lft.directive 'lfDeviceQueue', dDeviceQueue
