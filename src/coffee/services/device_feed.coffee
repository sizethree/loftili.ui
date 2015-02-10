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
    device_id = @device.id

    success = (response) =>
      fn(null, response) for fn in @listeners
      $timeout update, FEED_TIMEOUT

    fail = () =>
      fn(true, null) for fn in @listeners
      $timeout update, FEED_TIMEOUT

    request = () ->
      ping_request = Api.DeviceState.get
        device_id: device_id
      ping_request.$promise.then success, fail

    update = () =>
      if @looping
        request()
      else false

    # Socket.connect true

    update()

  class DeviceFeed

    constructor: (@device) ->
      @listeners = []
      @looping = false

    add: (update_fn, silent) ->
      if angular.isFunction update_fn
        added_id = addListener.call @, update_fn, silent

        if !@looping and silent != true
          @looping = true
          start.call @

        added_id
      else
        false

    refresh: () ->
      device_id = @device.id

      success = (response) =>
        fn(null, response) for fn in @listeners

      fail = () =>
        fn(true, null) for fn in @listeners

      ping_request = Api.DeviceState.get
        device_id: device_id
      ping_request.$promise.then success, fail

    remove: (fn_id, silent) ->
      for fn, indx in @listeners
        if fn.$$fn_id == fn_id
          @listeners.splice indx, 1
          break
      
      if @listeners.length == 0
        @looping = false

      if @listeners.length == 1 and @listeners[0].$$silent == true
        @listeners.splice 0, 1
        @looping = false


_factory.$inject = ['Api', 'Socket', '$timeout']

lft.service 'DeviceFeed', _factory
