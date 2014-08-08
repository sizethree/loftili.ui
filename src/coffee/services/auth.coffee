define [
  'ng'
  'services/api'
], (ng) ->

  active_user = null

  makeValidator = (level) ->

    validator = ($q, $location, Api) ->
      deferred = $q.defer()

      finish = (user) ->
        deferred.resolve user

      fail = () ->
        $location.path '/'

      check = () ->
        Api.Auth.check().$promise

      if active_user != null
        finish active_user
      else
        check().then finish, fail

      deferred.promise

    validator['$inject'] = ['$q', '$location', 'Api']
    validator


  class AuthResolver

    constructor: (access_level) ->
      @validator = makeValidator(access_level)

  class Auth

    constructor: () ->
      # chance for configuration

    resolver: AuthResolver

    $get: () ->
      () ->

    @$inject: []

  ng.module('lft').provider 'Auth', Auth

