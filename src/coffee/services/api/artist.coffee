ArtistFactory = ($resource, API_HOME) ->

  Artist = $resource [API_HOME, 'artists', ':artist_id'].join('/'), {}

lft.service 'Api/Artist', [
  '$resource',
  'API_HOME',
  ArtistFactory
]
