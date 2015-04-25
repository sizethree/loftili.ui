lft.config ['$routeProvider', ($routeProvider) ->

  callbacks = []

  next = (user) ->
    callback user for callback in callbacks

  $routeProvider.when '/dashboard/:child?',
    templateUrl: 'views.dashboard'
    controller: 'DashboardController'
    name: 'dashboard'
    resolve:
      childView: ['$route', ($route) ->
        current_route = $route.current
        if current_route.params and current_route.params['child']
          current_route.params['child']
        else
          'overview'
      ],

      activeUser: ['Auth', (Auth) ->
        callbacks = []
        active = Auth.filter 'active'
        active.then next
        active
      ],

      tracks: ['Api', '$q', (Api, $q) ->
        deferred = $q.defer()

        finish = (tracks) ->
          deferred.resolve tracks

        fail = () ->
          deferred.reject()

        tracks = (user) ->
          Api.User.tracks({user_id: user.id}).$promise.then finish, fail

        callbacks.push tracks
        deferred.promise
      ],

      devices: ['Api', '$q', (Api, $q) ->
        deferred = $q.defer()
    
        finish = (devices) ->
          deferred.resolve devices

        fail = () ->
          deferred.reject()

        devices = (user) ->
          devices = Api.Device.query
            user: user.id
          devices.$promise.then finish, fail

        callbacks.push devices
        deferred.promise
      ]

]
