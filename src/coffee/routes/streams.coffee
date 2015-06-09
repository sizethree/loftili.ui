rStreamRoute = ($routeProvider) ->

  resolve = ($q, $route, $location, Auth, StreamManager) ->
    deferred = $q.defer()
    current_route = $route.current
    stream_id = current_route.params.id
    manager = null

    finish = () ->
      deferred.resolve manager

    fail = () ->
      deferred.reject false
      $location.url '/dashboard'

    getStream = () ->
      manager = StreamManager stream_id
      manager.refresh().then finish, fail

    (Auth.filter 'active').then getStream, fail

    deferred.promise

  resolve.$inject = [
    '$q'
    '$route'
    '$location'
    'Auth'
    'StreamManager'
  ]

  StreamRoute =
    templateUrl: 'views.stream_management'
    controller: 'StreamManagementController'
    name: 'stream_management'
    title: 'Stream'
    resolve:
      resolved: resolve

  $routeProvider.when '/streams/:id', StreamRoute

rStreamRoute.$inject = [
  '$routeProvider'
]

lft.config rStreamRoute
