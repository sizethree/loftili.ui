_factory = (TooltipManager) ->

  lfTooltipMaestro =
    restrict: 'EA'
    replace: true
    templateUrl: 'directives.tooltip_maestro'
    link: ($scope, $element, $attrs) ->
      TooltipManager.on "transclude", (element) -> $element.append(element)

_factory.$inject = ['TooltipManager']

lft.directive 'lfTooltipMaestro', _factory
