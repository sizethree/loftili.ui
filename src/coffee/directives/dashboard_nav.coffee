lft.directive 'lfDashboardNav', [() ->

  lfDashboardNav =
    replace: true
    templateUrl: 'directives.dashboard_nav'
    scope:
      active: '='
    link: ($scope, $element, $attrs) ->

]
