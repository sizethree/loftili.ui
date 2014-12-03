lft.directive 'lfFooter', ['Analytics', (Analytics) ->

  lfFooter =
    replace: true
    templateUrl: 'directives.footer'
    scope: {}
    link: ($scope, $element, $attrs) ->
      $scope.track = (type, event) ->
        Analytics.event 'social', 'footer_click', type

]
