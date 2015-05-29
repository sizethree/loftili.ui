_factory = ($q, Api) ->

  class AccountManager

    constructor: (@user) ->

    update: (property, value) ->
      deferred = $q.defer()

      if angular.isObject property
        params = property
      else
        params = {id: @user.id}
        params[property] = value

      success = () ->
        deferred.resolve()

      fail = () ->
        deferred.reject()

      (Api.User.update params).$promise.then success, fail
      deferred.promise

_factory.$inject = ['$q', 'Api']

lft.service 'AccountManager', _factory
