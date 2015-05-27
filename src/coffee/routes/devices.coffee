rDeviceRoute = ($routeProvider) ->

  callbacks = []

  next = (user) ->
    callback user for callback in callbacks

  resolveQueue = ($q, $route, DeviceManager, Auth) ->
    deferred = $q.defer()
    current_route = $route.current
    device_id = current_route.params.id
    manager = DeviceManager
      id: device_id

    finish = (queue) ->
      deferred.resolve queue

    fail = () ->

    getQueue = () ->
      (manager.queue.load true).then finish, fail

    callbacks.push getQueue
    deferred.promise

  resolveQueue.$inject = ['$q', '$route', 'DeviceManager', 'Auth']

  resolvePermissions = ($q, $route, Api, Auth) ->
    deferred = $q.defer()
    current_route = $route.current
    device_id = current_route.params.id

    notCurrent = (device_permission) ->
      current_user = Auth.user()
      current_user.id != device_permission.user.id

    finish = (permissions) ->
      deferred.resolve permissions

    getPermissions = () ->
      request = Api.DevicePermission.search
        device: device_id
      request.$promise.then finish

    callbacks.push getPermissions
    deferred.promise

  resolvePermissions.$inject = ['$q', '$route', 'Api', 'Auth']

  resolveDeviceInfo = ($q, $route, Api) ->
    deferred = $q.defer()
    current_route = $route.current
    device_id = current_route.params.id

    device = null

    finish = (serial_number) ->
      deferred.resolve
        device: device
        serial_number: serial_number

    getSerial = () ->
      (Api.DeviceSerial.get
        id: device.serial_number).$promise.then finish, fail

    hasDevice = (d) ->
      device = d
      getSerial()

    fail = () ->
      deferred.reject false

    getDevice = () ->
      (Api.Device.get
        id: device_id).$promise.then hasDevice, fail

    callbacks.push getDevice
    deferred.promise

  resolveDeviceInfo.$inject = ['$q', '$route', 'Api']

  DeviceRoute =
    templateUrl: 'views.device_management'
    controller: 'DeviceManagementController'
    name: 'device_management'
    resolve:
      activeUser: ['Auth', (Auth) ->
        callbacks = []
        active = Auth.filter 'active'
        active.then next
        active
      ],
      device_info: resolveDeviceInfo
      device_queue: resolveQueue
      permissions: resolvePermissions

  $routeProvider.when '/devices/:id', DeviceRoute

rDeviceRoute.$inject = [
  '$routeProvider'
]

lft.config rDeviceRoute
