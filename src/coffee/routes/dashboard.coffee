lft.config ['$routeProvider', ($routeProvider) ->

  callbacks = []

  next = (user) ->
    callback user for callback in callbacks

  resolve = ($q, $route, Api, Auth) ->
    deferred = $q.defer()
    current_route = $route.current
    params = current_route.params

    resolved =
      childView: if params['child'] then params['child'] else 'overview'

    check = () ->
      if resolved.devices and resolved.streams
        deferred.resolve resolved

    loadedDevices = (devices) ->
      resolved.devices = devices
      check true

    loadedStreams = (streams) ->
      r = []
      r.push s.stream for s in streams
      resolved.streams = r
      check true

    loadedPermissions = (permissions) ->
      finished = []

      if permissions.data.length == 0
        resolved.devices = []
        return check()

      success = (device) ->
        finished.push device
        resolved.devices = finished if finished.length == permissions.data.length
        check()

      failDevice = () ->
        deferred.reject false

      loadDevice = (device) ->
        (Api.Device.get
          id: device.id or device).$promise.then success, failDevice

      loadDevice p.device for p in permissions.data
      true

    auth = (user_info) ->
      (Api.DevicePermission.query
        user: Auth.user().id).$promise.then loadedPermissions
      (Api.StreamPermission.query
        user: user_info.id).$promise.then loadedStreams

    fail = () ->
      deferred.reject false

    (Auth.filter 'active').then auth, fail

    deferred.promise

  resolve.$inject = [
    '$q',
    '$route',
    'Api',
    'Auth'
  ]


  $routeProvider.when '/dashboard/:child?',
    templateUrl: 'views.dashboard'
    controller: 'DashboardController'
    name: 'dashboard'
    resolve:
      resolved: resolve

]
