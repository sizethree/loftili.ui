AuthFactory = ['$resource', 'Api/User', 'URLS', ($resource, User, URLS) ->

  Auth = $resource [URLS.api, 'auth'].join('/'), {},
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
      url: [URLS.api, 'logout'].join('/')

]

lft.service 'Api/Auth', AuthFactory
