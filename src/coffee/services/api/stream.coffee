StreamFactory = ($resource, $q, URLS) ->

  defaults =
    id: '@id'

  Stream = $resource [URLS.api, 'streams', ':id'].join('/'), defaults,
    enqueue:
      url: [URLS.api, 'streams', ':id', 'queue'].join '/'
      method: 'PUT'
    dequeue:
      url: [URLS.api, 'streams', ':id', 'queue', ':position'].join '/'
      method: 'DELETE'
      params:
        id: '@id'
        position: '@position'

StreamFactory.$inject = ['$resource', '$q', 'URLS']

lft.service 'Api/Stream', StreamFactory
