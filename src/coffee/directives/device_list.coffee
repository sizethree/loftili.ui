lft.directive 'lfDeviceList', [() ->

  lfDeviceList =
    replace: true
    templateUrl: 'directives.device_list'
    scope:
      devices: '='
    link: ($scope, $element, $attrs) ->

      $scope.remove = (index) ->
        $scope.devices.splice index, 1

]
