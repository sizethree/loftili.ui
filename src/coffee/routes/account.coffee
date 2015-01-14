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
      clientTokens: ['Api', '$q', (Api, $q) ->
        deferred = $q.defer()

        success = (tokens) ->
          deferred.resolve tokens

        fail = () ->
          deferred.reject tokens

        getClientTokens = () ->
          request = Api.ClientToken.query()
          request.$promise.then success, fail

        callbacks.push getClientTokens
        deferred.promise
      ]
      clients: ['Api', '$q', (Api, $q) ->
        deferred = $q.defer()

        success = (clients) ->
          deferred.resolve clients

        fail = () ->
          deferred.reject()

        getClients = () ->
          request = Api.Client.query()
          request.$promise.then success, fail

        callbacks.push getClients
        deferred.promise
      ]

]
