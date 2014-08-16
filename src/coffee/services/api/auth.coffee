AuthFactory = ($resource, User, API_HOME) ->

  Auth = $resource [API_HOME, 'auth'].join('/'), {},
    check:
      method: 'GET'
      interceptor:
        response: (response) ->
          return new User(response.data)

    attempt:
      method: 'POST'
      interceptor:
        response: (response) ->
          return new User(response.data)

    logout:
      method: 'GET'
      url: [API_HOME, 'logout'].join('/')

lft.service 'Api/Auth', [
  '$resource',
  'Api/User',
  'API_HOME',
  AuthFactory
]
