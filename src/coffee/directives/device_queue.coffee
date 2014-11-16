lft.directive 'lfDeviceQueue', [() ->

  lfDeviceQueue =
    replace: true
    templateUrl: 'directives.device_queue'
    scope:
      device: '='
      queue: '='
    link: ($scope, $element, $attrs) ->
      console.log $scope.device


]
