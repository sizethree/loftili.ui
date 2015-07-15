sTrackCache = ($q, Api, ApiCache) ->

  ApiCache Api.Track

sTrackCache.$inject = [
  '$q',
  'Api',
  'ApiCache'
]

lft.service 'TrackCache', sTrackCache
