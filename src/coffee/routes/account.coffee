lft.config ['$routeProvider', ($routeProvider) ->

  callbacks = []

  next = (user) ->
    callback user for callback in callbacks

  $routeProvider.when '/account',
    templateUrl: 'views.account'
    controller: 'AccountController'
    name: 'account'
    resolve:

      activeUser: ['Auth', (Auth) ->
        callbacks = []
        active = Auth.filter 'active'
        active.then next
        active
      ]

]
