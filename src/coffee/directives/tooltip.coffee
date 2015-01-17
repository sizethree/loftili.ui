lft.directive 'lfTooltip', ['TooltipManager', (TooltipManager) ->

  lfTooltip =
    replace: true
    transclude: true
    templateUrl: 'directives.tooltip'
    compile: (element, attrs, transclude) ->
      link = ($scope, $element, $attrs) ->
        placement_scope = $scope.$new()

        $scope.hover = () -> $scope.$broadcast 'hover'
        $scope.off = () -> $scope.$broadcast 'off'

        transclusionFn = TooltipManager.transclusion $element, placement_scope
        child_scope = $scope
        transclude child_scope, transclusionFn

        $scope.$on '$destroy', () -> placement_scope.$destroy()

]
