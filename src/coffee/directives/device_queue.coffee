dDeviceQueue = (Notifications, Lang) ->

  dDeviceQueueLink = ($scope, $element, $attrs) ->
    $scope.adding = false

    $scope.searchToggle = () ->
      $scope.adding = !$scope.adding

    $scope.removeItem = (index) ->
      success = () ->
        $scope.queue.splice index, 1

      fail = () ->
        fail_lang = Lang 'queuing.failed_remove'
        Notifications.flash.error fail_lang

      ($scope.manager.queue.remove index).then success, fail

    listener = $scope.manager.queue.on 'add', () ->
      $scope.adding = false

    $scope.$on '$destroy', () ->
      $scope.manager.queue.off listener

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
