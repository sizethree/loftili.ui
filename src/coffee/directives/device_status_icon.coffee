_factory = () ->

  lfDeviceStatusIcon =
    restrict: 'AE'
    replace: true
    templateUrl: 'directives.device_status_icon'
    scope:
      manager: '='
    link: ($scope, $element, $attrs) ->
      feed_loop_id = null

      update = (err, ping_response) ->
        if err
          $scope.status = false
        else
          $scope.status = true
          $scope.last_checked = ping_response.last_checked

      feed_loop_id = $scope.manager.feed.add update

_factory.$inject = []

lft.directive 'lfDeviceStatusIcon', _factory
