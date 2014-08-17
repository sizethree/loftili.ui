PlaybackFactory = ($resource, API_HOME) ->

  Playback = $resource [API_HOME, 'playback', ':fn'].join('/'), {},
    start:
      method: 'POST'
      params:
        fn: 'start'
    stop:
      method: 'POST'
      params:
        fn: 'stop'

lft.service 'Api/Playback', [
  '$resource',
  'API_HOME',
  PlaybackFactory
]
