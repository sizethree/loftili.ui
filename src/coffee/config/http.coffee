lft.config ['$httpProvider', ($httpProvider) ->

  delete $httpProvider.defaults.useXDomain
  $httpProvider.defaults.withCredentials = true
  $httpProvider.defaults.headers.common = {}
  $httpProvider.defaults.headers.post = {}
  $httpProvider.defaults.headers.put = {}
  $httpProvider.defaults.headers.patch = {}

]
