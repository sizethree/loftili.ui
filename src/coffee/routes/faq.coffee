lft.config ['$routeProvider', ($routeProvider) ->

  url = (paths...) ->
    paths.join '/'

  post_filter = (id) ->
    ["filter[p]=", id].join ''

  FaQRoute =
    templateUrl: 'views.faq'
    controller: 'FaqController'
    title: 'FAQ'
    name: 'faq'
    resolve:
      activeUser: ['Auth', (Auth) ->
        Auth.filter 'guest'
      ]
      content: ['$http', '$q', 'URLS', ($http, $q, URLS) ->
        deferred = $q.defer()
        query = post_filter 182

        success = (response) ->
          content = response.data[0].content
          deferred.resolve content

        fail = () ->

        promise = $http
          url: url(URLS.blog, 'pages') + '?' + query
          withCredentials: false

        promise.then success, fail

        deferred.promise
      ]

  $routeProvider.when '/faq', FaQRoute

]

