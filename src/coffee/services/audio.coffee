do ->
  soundManager.setup
    url: '/swf/'
    preferFlash: true
    useHTML5Audio: false

_factory = (URLS) ->

  listeners:
    start: []
    stop: []
    finish: []

  current_sound = null

  class Sound

    constructor: (@data) ->
      @listeners =
        start: []
        stop: []
        finish: []

      @sound_obj = soundManager.createSound
        url: @data.streaming_url

    on: (evt, fn) ->
      is_list = angular.isArray @listeners[evt]
      is_fn = angular.isFunction fn
      if is_list and is_fn
        @listeners[evt].push fn

    trigger: (evt, args...) ->
      has_callbacks = angular.isArray @listeners[evt]

      if has_callbacks
        fn.apply null, args for fn in @listeners[evt]

    play: () ->
      if current_sound
        current_sound.stop()

      @sound_obj.play()
      current_sound = @

      @trigger 'start'

    stop: () ->
      @sound_obj.stop()
      @trigger 'stop'

  AudioManager =

    Sound: Sound

  AudioManager.on = (evt, fn) ->
    is_fn = angular.isFunction fn
    has_evt = angular.isArray listeners[evt]

    if is_fn and has_evt
      listeners[evt].push fn

  AudioManager

_factory.$inject = ['URLS']

lft.service 'Audio', _factory
