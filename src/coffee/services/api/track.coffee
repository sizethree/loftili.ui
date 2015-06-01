TrackFactory = ['$resource', '$q', 'URLS', ($resource, $q, URLS) ->

  defaults =
    id: '@id'


  Track = $resource [URLS.api, 'tracks', ':id'].join('/'), defaults,
    upload:
      method: 'POST'
      url: [URLS.api, 'tracks', 'upload'].join '/'
      transformRequest: (data) ->
        fdt = new FormData()
        fdt.append 'file', data.track_file
        fdt

    update:
      method: 'PUT'

    search:
      method: 'GET'
      isArray: true
      url: [URLS.api, 'tracks', 'search'].join '/'

    scout:
      method: 'GET'
      url: [URLS.api, 'tracks', 'scout'].join '/'

]

lft.service 'Api/Track', TrackFactory
