sArtistCache = ($q, Api, ApiCache) ->

  ApiCache Api.Artist

sArtistCache.$inject = [
  '$q',
  'Api',
  'ApiCache'
]

lft.service 'ArtistCache', sArtistCache
