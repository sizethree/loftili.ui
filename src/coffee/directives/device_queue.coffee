lft.directive 'lfDeviceQueue', ['$timeout', 'Api', 'DEVICE_STATES', ($timeout, Api, DEVICE_STATES) ->

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

]
