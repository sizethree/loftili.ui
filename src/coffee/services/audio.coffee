_factory = (URLS) ->

  current_sound = null

  class Sound

    constructor: (@data) ->
      @listeners = []

      @sound_obj = soundManager.createSound
        url: @data.streaming_url
        volume: 1

        onfinish: () =>
          @trigger 'finish'

        whileplaying: () =>
          @trigger 'playback'

        onload: () =>
          @trigger 'loaded'

    on: (evt, fn) ->
      is_fn = angular.isFunction fn
      @listeners.push {evt: evt, fn: fn} if is_fn

    trigger: (evt, args...) ->
      for l in @listeners
        l.fn.apply null, args if l.evt == evt

    play: () ->
      if current_sound
        current_sound.stop()

      @sound_obj.play()
      current_sound = @

      @trigger 'start'

    pause: () ->
      @sound_obj.pause()
      @trigger 'paused'

    stop: () ->
      @sound_obj.stop()
      @trigger 'stop'

  AudioManager =

    Sound: Sound

  AudioManager

_factory.$inject = ['URLS']

lft.service 'Audio', _factory
