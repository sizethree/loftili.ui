lft.config ['$routeProvider', ($routeProvider) ->

  about_id = 44
  contact_id = 431
  home_id = 121

  url = (paths...) ->
    paths.join '/'

  post_filter = (id) ->
    ["filter[p]=", id].join ''

  $routeProvider.when '/',
    templateUrl: 'views.home'
    controller: 'HomeController'
    title: 'home'
    name: 'home'
    resolve:
      activeUser: ['Auth', (Auth) ->
        Auth.filter 'guest'
      ]
      content: ['$http', '$q', 'URLS', ($http, $q, URLS) ->
        deferred = $q.defer()
        query = post_filter home_id

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

  $routeProvider.when '/about',
    templateUrl: 'views.about'
    controller: 'AboutController'
    title: 'about'
    name: 'about'
    resolve:
      content: ['$http', '$q', 'URLS', ($http, $q, URLS) ->
        deferred = $q.defer()
        query = post_filter about_id

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

  $routeProvider.when '/contact',
    templateUrl: 'views.contact'
    controller: 'ContactController'
    title: 'contact'
    name: 'contact'
    resolve:
      content: ['$http', '$q', 'URLS', ($http, $q, URLS) ->
        deferred = $q.defer()
        query = post_filter contact_id

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

  $routeProvider.otherwise
    redirectTo: '/'

]
