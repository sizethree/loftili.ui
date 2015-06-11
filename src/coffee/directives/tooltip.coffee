_factory = (TooltipManager) ->

  compile = (element, attrs, transclude) ->
    link = ($scope, $element, $attrs) ->
      placement_scope = $scope.$new()

      $scope.hover = () -> $scope.$broadcast 'hover'
      $scope.off = () -> $scope.$broadcast 'off'

      transclusionFn = TooltipManager.transclusion $element, placement_scope
      child_scope = $scope.$parent
      transclude child_scope, transclusionFn

      $scope.$on '$destroy', () -> placement_scope.$destroy()

  lfTooltip =
    replace: true
    transclude: true
    templateUrl: 'directives.tooltip'
    scope: {}
    compile: compile

_factory.$inject = [
  'TooltipManager'
]

lft.directive 'lfTooltip', _factory
