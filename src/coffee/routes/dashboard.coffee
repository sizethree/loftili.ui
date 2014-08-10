lft.config ['$routeProvider', ($routeProvider) ->

  $routeProvider.when '/dashboard',
    templateUrl: 'views.dashboard'
    controller: 'DashboardController'
    resolve:
      activeUser: ['Auth', (Auth) ->
        Auth.filter 'active'
      ],

      tracks: ['Api', (Api) ->
        tracks = Api.Track.query()
        tracks.$promise
      ],

      devices: ['Api', (Api) ->
        devices = Api.Device.query()
        devices.$promise
      ]

]
