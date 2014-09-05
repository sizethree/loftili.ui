ArtistFactory = ['$resource', 'URLS', ($resource, URLS) ->

  Artist = $resource [URLS.api, 'artists', ':artist_id'].join('/'), {}

]

lft.service 'Api/Artist', ArtistFactory
