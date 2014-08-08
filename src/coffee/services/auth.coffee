define [
  'ng'
  'services/api'
], (ng) ->

  active_user = null

  class AuthResolver

    constructor: (callback) ->
      @validator = ($q, $location, Api) ->
        defer = $q.defer()
        
        active = (user) ->
          callback user, defer, $location

        guest = () ->
          active_user = false
          callback false, defer, $location

        if active_user == null
          Api.Auth.check().$promise.then active, guest
        else if active_user == false
          guest()
        else
          active(active_user)


        defer.promise

      @validator['$inject'] = ['$q', '$location', 'Api']

  class Auth

    constructor: () ->
      # chance for configuration

    filter: (type) ->
      switch type
        when 'guest'
          finish = (user, promise, $location) ->
            if user
              $location.path '/dashboard'
            else
              promise.resolve()
        when 'active'
          finish = (user, promise, $location) ->
            if !user
              $location.path '/'
            else
              promise.resolve(user)

      resolver = new AuthResolver(finish)
      resolver

    $get: ['Api', (Api) ->
      logout: () ->
        Api.Auth.logout()
    ]

    @$inject: []

  ng.module('lft').provider 'Auth', Auth

