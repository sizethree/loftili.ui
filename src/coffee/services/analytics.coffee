lft.service 'Analytics', ['GOOGLE', '$rootScope', '$location', (GOOGLE, $rootScope, $location) ->

  current_route_listener = null

  ga 'create', GOOGLE.tracking, 'auto'

  Analytics =

    track: (path, title) ->
      ga 'send', 'pageview',
        page: path,
        title: title
    
    event: (category, action, label, value) ->
      ga 'send', 'event', category, action, label, value

  routeStart = () ->
    start_time = new Date().getTime()

    if current_route_listener != null
      current_route_listener()
      current_route_listener = null

    success = (evt, route_info) ->
      end_time = new Date().getTime()
      current_route = route_info.$$route

      if current_route
        Analytics.track $location.url(), current_route.title
        Analytics.event 'routing', 'loadtime', $location.url(), (end_time - start_time)

      detatch()
      current_route_listener = null

    detatch = $rootScope.$on '$routeChangeSuccess', success

    current_route_listener = () ->
      detatch()

  $rootScope.$on '$routeChangeStart', routeStart

  Analytics

]
