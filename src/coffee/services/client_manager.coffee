_factory = ($q, Api) ->

  uuid = do ->
    indx = 0
    () ->
      indx++
      [indx, '$'].join('-')

  trigger = (evt, p1, p2) ->
    callbacks = @callbacks[evt]
    fn(p1, p2) for fn in callbacks

  class ClientManager

    constructor: (@tokens, @clients) ->
      @callbacks =
        added: []
        removed: []

    on: (evt, fn) ->
      callbacks = @callbacks[evt]
      if angular.isArray callbacks
        cb_uid = uuid()
        wrapper = (p1, p2) -> fn(p1, p2)
        wrapper.id = cb_uid
        callbacks.push wrapper
        cb_uid
      else
        false

    removeClient: (token) ->
      deferred = $q.defer()

      success = () =>
        trigger.call @, 'removed'
        deferred.resolve()

      fail = () ->
        deferred.reject()

      request = Api.ClientToken.destroy
        token_id: token.id

      request.$promise.then success, fail

      deferred.promise

    addClient: (client) ->
      deferred = $q.defer()

      success = (token) =>
        trigger.call @, 'added', token
        deferred.resolve token

      fail = () ->
        deferred.reject()

      new_token = new Api.ClientToken.save
        client: client.id

      new_token.$promise.then success, fail

      deferred.promise

_factory.$inject = ['$q', 'Api']

lft.service 'ClientManager', _factory
