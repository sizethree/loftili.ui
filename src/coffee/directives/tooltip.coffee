lft.directive 'lfTooltip', [() ->

  lfTooltip =
    replace: true
    transclude: true
    templateUrl: 'directives.tooltip'
    link: ($scope, $element, $attrs) ->
      content_path = ['.tooltip-inner', '.content']
      $content = $element

      while(content_path.length)
        next_level = content_path.splice(0,1)[0]
        $content = $content.children next_level

      $scope.vis = false

      $scope.hover = () ->
        height = $content[0].offsetHeight
        $content.css
          top: (-(height + 8) + 'px')
        $scope.vis = true

      $scope.off = () ->
        $content.css
          top: '0px'
        $scope.vis = false

]
