_factory = () ->

  to_i = (num) -> parseInt num, 10

  link = ($scope, $element, $attrs) ->

  lfDeviceStatusIcon =
    restrict: 'AE'
    replace: true
    templateUrl: 'directives.device_status_icon'
    scope:
      manager: '='
    compile: () ->
      link

_factory.$inject = []

lft.directive 'lfDeviceStatusIcon', _factory
