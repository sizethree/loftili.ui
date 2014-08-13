lft.service 'Auth', ['$q', '$http', '$location', 'Api', ($q, $http, $location, Api) ->
  
  active_user = null

  filter = (type) ->
    defer = $q.defer()

    redirect = (path) ->
      defer.reject()
      $location.path(path)

    success = (user) ->
      active_user = user
      if type == 'guest'
        redirect('/dashboard')
      else
        defer.resolve(active_user)

    fail = () ->
      active_user = false
      if type == 'active'
        redirect('/')
      else
        defer.resolve()

    if active_user == null
      Api.Auth.check().$promise.then success, fail
    else
      if active_user != false then success(active_user) else fail()

    defer.promise

  Auth =
    filter: filter
    user: () -> active_user
    logout: () ->
      active_user = null
      Api.Auth.logout().$promise.then () -> $location.path('/')
    attempt: (creds) ->
      defer = $q.defer()

      success = (user) ->
        $http.defaults.headers.common.Authorization = ['Basic', user.id].join(' ')
        active_user = user
        defer.resolve user

      fail = () ->
        active_user = false
        defer.reject()

      Api.Auth.attempt(creds).$promise.then success, fail

      defer.promise

]
