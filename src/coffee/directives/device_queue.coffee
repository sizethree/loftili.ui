lft.directive 'lfDeviceQueue', ['$timeout', 'Api', ($timeout, Api) ->

  lfDeviceQueue =
    replace: true
    templateUrl: 'directives.device_queue'
    scope:
      manager: '='
      queue: '='
    link: ($scope, $element, $attrs) ->
      looping = false

      finish = (new_queue) ->
        $scope.queue = new_queue

        if looping
          $timeout update, 1000

      update = () ->
        $scope.manager.getQueue().then finish

      cleanup = () ->
        looping = false

      startLoop = () ->
        if looping == false
          looping = true
          update()

      $scope.manager.on 'stop', cleanup
      $scope.manager.on 'start', startLoop

      $element.on '$destroy', cleanup

      startLoop()

]
