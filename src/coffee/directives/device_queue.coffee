_factory = ($timeout, DEVICE_STATES, Notifications, Lang) ->

  lfDeviceQueue =
    replace: true
    templateUrl: 'directives.device_queue'
    scope:
      manager: '='
      queue: '='
    link: ($scope, $element, $attrs) ->
      looping = false
      feed_loop_id = null
      $scope.adding = false

      $scope.searchToggle = () ->
        $scope.adding = !$scope.adding

      $scope.removeItem = (item_index) ->
        success = (new_queue) ->
          $scope.queue = new_queue

        fail = () ->
          failed_lang = Lang 'queuing.failed_remove'
          Notifications.flash failed_lang, 'error'

        $scope.manager.removeQueueItem(item_index).then success, fail

      receiveQueue = (queue) ->
        $scope.queue = queue

      update = (err, response) ->
        $scope.manager.getQueue().then receiveQueue, receiveQueue

      $scope.$on '$destroy', () ->
        $scope.manager.feed.remove feed_loop_id

      feed_loop_id = $scope.manager.feed.add update

_factory.$inject = ['$timeout', 'DEVICE_STATES', 'Notifications', 'Lang']

lft.directive 'lfDeviceQueue', _factory
