lft.config ['$routeProvider', ($routeProvider) ->

  callbacks = []

  next = (user) ->
    callback user for callback in callbacks

  $routeProvider.when '/devices/:id',
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
      device: ['$q', '$route', 'Api', ($q, $route, Api) ->
        deferred = $q.defer()
        current_route = $route.current
        device_id = current_route.params.id
        target_device = new Api.Device
          id: device_id

        finish = (device) ->
          deferred.resolve device

        getDevice = () ->
          promise = target_device.$get()
          promise.then finish

        callbacks.push getDevice
        deferred.promise
      ]
      device_queue: ['$q', '$route', 'Api', 'Auth', ($q, $route, Api, Auth) ->
        deferred = $q.defer()
        current_route = $route.current
        device_id = current_route.params.id

        finish = (device_queue) ->
          deferred.resolve device_queue.queue

        getQueue = () ->
          request = Api.TrackQueue.get
            id: device_id
          request.$promise.then finish

        callbacks.push getQueue
        deferred.promise
      ]
      permissions: ['$q', '$route', 'Api', 'Auth', ($q, $route, Api, Auth) ->
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
      ]

]

