lft.directive 'lfDashboardNav', [() ->

  lfDashboardNav =
    replace: true
    templateUrl: 'directives.dashboard_nav'
    scope:
      active: '='
    link: ($scope, $element, $attrs) ->
      console.log $scope.active

]
