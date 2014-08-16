TrackFactory = ($resource, $q, API_HOME) ->

  Track = $resource [API_HOME, 'tracks', ':track_id'].join('/'), {},
    upload:
      method: 'POST'
      params:
        track_id: 'upload'
      transformRequest: (data) ->
        fdt = new FormData()
        fdt.append 'file', data.track_file
        fdt

  Track

lft.service 'Api/Track', [
  '$resource',
  '$q',
  'API_HOME',
  TrackFactory
]

