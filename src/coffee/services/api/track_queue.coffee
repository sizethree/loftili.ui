TrackQueueService = ['$resource', 'URLS', ($resource, URLS) ->

  TrackQueue = $resource [URLS.api, 'queues', ':id'].join('/')

]

lft.service 'Api/TrackQueue', TrackQueueService

