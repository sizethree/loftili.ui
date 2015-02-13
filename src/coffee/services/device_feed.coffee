_factory = (Api, Socket, $timeout) ->

  FEED_TIMEOUT = 100000

  uuid = do ->
    indx = 0
    () ->
      ['feed_fn', indx++].join '-'

  addListener = (fn, was_silent) ->
    fn_uid = uuid()
    wrapper = (err, response) -> fn(err, response)
    wrapper.$$fn_id = fn_uid
    wrapper.$$silent = was_silent
    @listeners.push wrapper
    fn_uid

  start = () ->
    Socket.connect true

  class DeviceFeed

    constructor: (@device) ->
      @listeners = []
      @listening = false

    add: (update_fn, silent) ->
      if angular.isFunction update_fn
        added_id = addListener.call @, update_fn, silent

        if !@listening and silent != true
          @listening = true
          start.call @

        added_id
      else
        false

    refresh: () ->

    remove: (fn_id, silent) ->
      for fn, indx in @listeners
        if fn.$$fn_id == fn_id
          @listeners.splice indx, 1
          break
      
      silent_listeners = []
      silent_listeners.push listener if listener.$$silent == true for listener in @listeners

      if @listeners.length == 0 or silent_listeners.length == @listeners.length
        @listeners = []
        console.log 'empty'


_factory.$inject = ['Api', 'Socket', '$timeout']

lft.service 'DeviceFeed', _factory
