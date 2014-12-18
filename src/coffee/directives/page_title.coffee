lft.directive 'lfPageTitle', ['$rootScope', 'Analytics', ($rootScope, Analytics) ->

  default_title = 'home audio. in the cloud'

  lfPageTitle =
    scope: {}
    link: ($scope, $element, $attrs) ->
      update = (evt, route_event) ->
        route = route_event.$$route
        if route
          title = ['loftili', route.title || default_title].join ' | '
          $element.html title

      start = (evt, route_event) ->
        route = route_event.$$route

      error = (evt, route_event) ->
        route = route_event.$$route

      $rootScope.$on '$routeChangeStart', start
      $rootScope.$on '#routeChangeError', error
      $rootScope.$on '$routeChangeSuccess', update

]
