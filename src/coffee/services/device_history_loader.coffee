sDeviceHistoryLoader = ($q, Api, TrackCache) ->

  track_cache = {}

  HistoryLoader = (device) ->
    Loader =
      page: 0
      history: []

    Loader.next = () ->
      deferred = $q.defer()
      finished = 0
      track_ids = []

      fail = () ->
        deferred.reject false

      finish = () ->
        deferred.resolve Loader.history

      loaded = () ->
        finish() if ++finished == track_ids.length
        true

      success = (history) ->

        history = history.sort (a, b) ->
          da = (new Date a.createdAt).getTime()
          ba = (new Date b.createdAt).getTime()
          if da > ba then -1 else 1

        console.log history

        Loader.history = history
        (track_ids.push h.track for h in history when (track_ids.indexOf h.track) < 0)
        ((TrackCache id).then loaded, fail for id in track_ids)
        true

      (Api.DeviceHistory.get
        id: device.id).$promise.then success, fail

      deferred.$promise

    Loader


sDeviceHistoryLoader.$inject = [
  '$q',
  'Api',
  'TrackCache'
]

lft.service 'DeviceHistoryLoader', sDeviceHistoryLoader

