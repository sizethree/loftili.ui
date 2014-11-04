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

]

