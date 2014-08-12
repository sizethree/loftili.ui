lft.directive 'lfDeviceList', [() ->

  lfDeviceList =
    replace: true
    templateUrl: 'directives.device_list'
    scope:
      devices: '='
    link: ($scope, $element, $attrs) ->
      console.log $element

]
