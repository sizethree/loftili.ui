_factory = (Api, $timeout) ->

  uuid = do ->
    indx = 0
    () ->
      ['feed_fn', indx++].join '-'

  addListener = (fn) ->
    fn_uid = uuid()
    wrapper = (err, response) -> fn(err, response)
    wrapper.$$fn_id = fn_uid
    @listeners.push wrapper
    fn_uid

  start = () ->
    @looping = true
    device_id = @device.id

    success = (response) =>
      fn(null, response) for fn in @listeners
      $timeout update, 1000

    fail = () =>
      fn(true, null) for fn in @listeners
      $timeout update, 1000

    request = () ->
      ping_request = Api.Device.ping
        device_id: device_id
      ping_request.$promise.then success, fail

    update = () =>
      if @looping
        request()
      else false

    update()

  class DeviceFeed

    constructor: (@device) ->
      @listeners = []
      @looping = false

    add: (update_fn) ->
      if angular.isFunction update_fn
        added_id = addListener.call @, update_fn
        if @listeners.length == 1
          start.call @
        added_id
      else
        false

    remove: (fn_id) ->
      for fn, indx in @listeners
        if fn.$$fn_id == fn_id
          @listeners.splice indx, 1
          break
      
      if @listeners.length == 0
        @looping = false


_factory.$inject = ['Api', '$timeout']

lft.service 'DeviceFeed', _factory
