lft.config ['$routeProvider', ($routeProvider) ->

  $routeProvider.when '/',
    templateUrl: 'views.home'
    controller: 'HomeController'
    resolve:
      activeUser: ['Auth', (Auth) ->
        Auth.filter 'guest'
      ]

]
