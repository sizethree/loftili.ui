ArtistFactory = ['$resource', 'URLS', ($resource, URLS) ->

  default_params =
    id: '@id'

  Artist = $resource [URLS.api, 'artists', ':id'].join('/'), default_params

]

lft.service 'Api/Artist', ArtistFactory
