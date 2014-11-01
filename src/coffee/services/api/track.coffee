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

    update:
      method: 'PUT'
      params:
        track_id: '@id'

    search:
      method: 'GET'
      isArray: true
      params:
        track_id: 'search'

    scout:
      method: 'GET'
      params:
        track_id: 'scout'

]

lft.service 'Api/Track', TrackFactory
