do ->

  factory = () ->
    a = 0
    $timeout = arguments[a++]
    Api = arguments[a++]
    DEVICE_STATES = arguments[a++]
    Notifications = arguments[a++]
    Lang = arguments[a++]

    lfDeviceQueue =
      replace: true
      templateUrl: 'directives.device_queue'
      scope:
        manager: '='
        queue: '='
      link: ($scope, $element, $attrs) ->
        looping = false
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

        finish = (new_queue) ->
          $scope.queue = new_queue

          if looping
            $timeout update, 1000

        update = () ->
          $scope.manager.getQueue().then finish

        cleanup = () ->
          looping = false

        receiveState = (response, state) ->
          if state == DEVICE_STATES.PLAYING
            startLoop()

        startLoop = () ->
          if looping == false
            looping = true
            update()

        $scope.manager.on 'stop', cleanup
        $scope.manager.on 'start', startLoop

        $element.on '$destroy', cleanup

        $scope.manager.getState().then receiveState

  factory.$inject = [
    '$timeout',
    'Api',
    'DEVICE_STATES',
    'Notifications',
    'Lang'
  ]
  
  lft.directive 'lfDeviceQueue', factory
