sBrowserPlayback = ($rootScope, $q, Api, Audio) ->

  Playback =
    current: false
    stream: false

  listeners = []
  current_list = []
  subsribed_to = null

  trigger = (evt) ->
    for l in listeners
      l.fn() if l.evt == evt

  refresh = () ->
    deferred = $q.defer()

    success = (stream_info) ->
      current_list = stream_info.queue
      Playback.stream = stream_info
      deferred.resolve true

    fail = () ->
      deferred.resolve false

    (Api.Stream.get
      id: subsribed_to).$promise.then success, fail

    deferred.promise

  Playback.on = (evt, fn) ->
    can_add = (angular.isFunction fn) and (angular.isString evt)
    listeners.push {evt: evt, fn: fn} if can_add
    true

  Playback.start = () ->
    first = current_list[0]
    sound = new Audio.Sound first
    Playback.current = sound

    sound.on 'loaded', () ->
      $rootScope.$apply () -> trigger 'update'

    sound.on 'playback', () ->
      $rootScope.$digest()

    sound.on 'finish', () ->
      current_list.shift()
      Playback.start()

    sound.play()

  Playback.pause = () ->
    Playback.current.pause() if Playback.current

  Playback.stop = () ->
    Playback.current.stop() if Playback.current
    Playback.current = null
    Playback.stream = null
    trigger 'update'

  Playback.subscribe = (stream_id) ->
    deferred = $q.defer()

    subsribed_to = stream_id

    loaded = () ->
      Playback.start()
      deferred.resolve true

    fail = () ->
      deferred.reject false

    (refresh true).then loaded, fail

    deferred.promise

  Playback

sBrowserPlayback.$inject = [
  '$rootScope'
  '$q'
  'Api'
  'Audio'
]

lft.service 'BrowserPlayback', sBrowserPlayback
