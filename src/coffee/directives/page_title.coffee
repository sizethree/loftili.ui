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
          Analytics.track route.originalPath, route.title

      start = (evt, route_event) ->
        route = route_event.$$route
        Analytics.event 'routing', 'route_start', route.originalPath

      error = (evt, route_event) ->
        route = route_event.$$route
        Analytics.event 'routing', 'route_error', route.originalPath

      $rootScope.$on '$routeChangeStart', start
      $rootScope.$on '#routeChangeError', error
      $rootScope.$on '$routeChangeSuccess', update

]
