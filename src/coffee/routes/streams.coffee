rStreamRoute = ($routeProvider) ->

  resolve = ($q, $route, $location, Auth, Api, StreamManager) ->
    deferred = $q.defer()
    current_route = $route.current
    stream_id = current_route.params.id
    manager = null
    devices = null
    finished = 0

    finish = () ->
      deferred.resolve
        manager: manager
        devices: devices

    fail = () ->
      deferred.reject false
      $location.url '/dashboard'

    loadedManager = () ->
      finish() if ++finished == 2

    loadedDevices = (result) ->
      devices = result
      finish() if ++finished == 2

    getStream = () ->
      manager = StreamManager stream_id
      manager.refresh().then loadedManager, fail
      (Api.Device.query
        user: Auth.user().id).$promise.then loadedDevices, fail
        

    (Auth.filter 'active').then getStream, fail

    deferred.promise

  resolve.$inject = [
    '$q'
    '$route'
    '$location'
    'Auth'
    'Api'
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
