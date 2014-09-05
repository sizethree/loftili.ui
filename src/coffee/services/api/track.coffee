TrackFactory = ['$resource', '$q', 'URLS', ($resource, $q, URLS) ->

  Track = $resource [URLS.api, 'tracks', ':track_id'].join('/'), {},
    upload:
      method: 'POST'
      params:
        track_id: 'upload'
      transformRequest: (data) ->
        fdt = new FormData()
        fdt.append 'file', data.track_file
        fdt

]

lft.service 'Api/Track', TrackFactory
