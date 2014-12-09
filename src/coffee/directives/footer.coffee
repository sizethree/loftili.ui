lft.directive 'lfFooter', ['Analytics', (Analytics) ->

  lfFooter =
    replace: true
    templateUrl: 'directives.footer'
    scope: {}
    link: ($scope, $element, $attrs) ->
      $scope.links_open = false

      $scope.toggleLinks = () ->
        $scope.links_open = !$scope.links_open

      $scope.track = (type, event) ->
        Analytics.event 'social', 'footer_click', type

]
