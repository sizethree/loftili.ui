lft.service 'Api', ['$resource', 'API_HOME', ($resource, API_HOME) ->

  Api = {}

  Api.User = $resource [API_HOME, 'users', ':user_id'].join('/')

  Api.Auth = $resource [API_HOME, 'auth'].join('/'), {},
    check:
      method: 'GET'
    attempt:
      method: 'POST'
    logout:
      method: 'DELETE'

  Api

]
