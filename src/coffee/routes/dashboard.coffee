lft.config ['$routeProvider', ($routeProvider) ->

  callbacks = []
  next = (user) ->
    callback user for callback in callbacks

  $routeProvider.when '/dashboard',
    templateUrl: 'views.dashboard'
    controller: 'DashboardController'
    resolve:
      activeUser: ['Auth', (Auth) ->
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
          Api.User.devices({user_id: user.id}).$promise.then finish, fail

        callbacks.push devices
        deferred.promise
      ]

]
