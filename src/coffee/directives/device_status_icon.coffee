_factory = () ->

  lfDeviceStatusIcon =
    restrict: 'AE'
    replace: true
    templateUrl: 'directives.device_status_icon'
    scope:
      manager: '='
    link: ($scope, $element, $attrs) ->
      feed_loop_id = null
      $scope.time_diff = 1

      update = (err, ping_response) ->
        current_time = new Date().getTime()

        if err
          $scope.status = false
        else
          timestamp = ping_response.timestamp
          diff = current_time - timestamp
          $scope.time_diff = Math.round diff * 0.001
          $scope.status = true

      $scope.$on '$destroy', () ->
        $scope.manager.feed.remove feed_loop_id

      feed_loop_id = $scope.manager.feed.add update

_factory.$inject = []

lft.directive 'lfDeviceStatusIcon', _factory
