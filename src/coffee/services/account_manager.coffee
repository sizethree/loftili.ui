_factory = ($q, Api) ->

  class AccountManager

    constructor: (@user) ->

    update: (property, value) ->
      deferred = $q.defer()

      params =
        id: @user.id

      success = () ->
        deferred.resolve()

      fail = () ->
        deferred.reject()

      params[property] = value

      request = Api.User.update params

      request.$promise.then success, fail

      deferred.promise

_factory.$inject = ['$q', 'Api']

lft.service 'AccountManager', _factory
