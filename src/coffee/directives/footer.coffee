lft.directive 'lfFooter', ['Analaytics', (Analaytics) ->

  lfFooter =
    replace: true
    templateUrl: 'directives.footer'
    scope: {}
    link: ($scope, $element, $attrs) ->
      $scope.track = (type, event) ->
        Analaytics.event 'social', 'footer_click', type

]
