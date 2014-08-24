lft.directive 'lfPageTitle', ['$rootScope', ($rootScope) ->

  default_title = 'home audio. in the cloud'

  lfPageTitle =
    scope: {}
    link: ($scope, $element, $attrs) ->
      update = (evt, route_event) ->
        route = route_event.$$route
        title = ['loftili', route.title || default_title].join ' | '
        $element.html title

      $rootScope.$on '$routeChangeSuccess', update

]
