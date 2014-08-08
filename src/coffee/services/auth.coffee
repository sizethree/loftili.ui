define [
  'ng'
  'services/api'
], (ng) ->

  active_user = null

  class AuthResolver

    constructor: (access_level) ->
      @validator = ($q, Api) =>
        deferred = $q.defer()

        finish = (user) ->
          deferred.resolve user

        fail = () ->
          console.log 'auth failed'

        check = () ->
          Api.Auth.check().$promise

        if active_user != null
          finish active_user
        else
          check().then finish, fail

        deferred.promise
      @validator['$inject'] = ['$q', 'Api']

  class Auth

    constructor: () ->
      # chance for configuration

    resolver: AuthResolver

    $get: () ->
      () ->

    @$inject: []

  ng.module('lft').provider 'Auth', Auth

