lft.config ['$httpProvider', ($httpProvider) ->

  $httpProvider.defaults.useXDomain = true
  $httpProvider.defaults.withCredentials = true
  $httpProvider.defaults.headers.common = {}
  $httpProvider.defaults.headers.post = {}
  $httpProvider.defaults.headers.put = {}
  $httpProvider.defaults.headers.patch = {}
  
]
