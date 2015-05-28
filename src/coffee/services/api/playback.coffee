PlaybackFactory = ['$resource', 'URLS', ($resource, URLS) ->

  Playback = $resource [URLS.api, 'playback', ':fn'].join('/'), {},
    skip:
      method: 'POST'
      params:
        fn: 'skip'
    restart:
      method: 'POST'
      params:
        fn: 'restart'
    start:
      method: 'POST'
      params:
        fn: 'start'
    stop:
      method: 'POST'
      params:
        fn: 'stop'

]

lft.service 'Api/Playback', PlaybackFactory
