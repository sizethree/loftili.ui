lft.directive 'lfDynamicContent', ['$compile', ($compile) ->

  lfDynamicContent =
    scope:
      content: '='
    link: ($scope, $element, $attrs) ->
      html = $compile($scope.content)($scope)
      $element.append html

]
