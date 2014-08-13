lft.config ['$routeProvider', ($routeProvider) ->

  $routeProvider.when '/',
    templateUrl: 'views.home'
    controller: 'HomeController'
    resolve:
      activeUser: ['Auth', (Auth) ->
        Auth.filter 'guest'
      ],
      device: ['Api', (Api) ->
        device = new Api.Device
          id: 1
        device.$register()
      ]

]
