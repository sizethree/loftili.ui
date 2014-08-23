lft.config ['$routeProvider', ($routeProvider) ->

  about_id = 44
  contact_id = 58
  blog_home = "http://blog.loftili.com/json"
  page_url = [blog_home, 'pages'].join '/'
  post_url = [blog_home, 'posts'].join '/'

  post_filter = (id) ->
    ["filter[p]=", id].join ''

  $routeProvider.when '/',
    templateUrl: 'views.home'
    controller: 'HomeController'
    resolve:
      activeUser: ['Auth', (Auth) ->
        Auth.filter 'guest'
      ]

  $routeProvider.when '/about',
    templateUrl: 'views.about'
    controller: 'AboutController'
    resolve:
      content: ['$http', '$q', ($http, $q) ->
        deferred = $q.defer()
        query = post_filter about_id

        success = (response) ->
          content = response.data[0].content
          deferred.resolve content

        fail = () ->

        promise = $http
          url: [page_url, query].join '?'
          withCredentials: false

        promise.then success, fail

        deferred.promise
      ]

  $routeProvider.when '/contact',
    templateUrl: 'views.contact'
    controller: 'ContactController'
    resolve:
      content: ['$http', '$q', ($http, $q) ->
        deferred = $q.defer()
        query = post_filter contact_id

        success = (response) ->
          content = response.data[0].content
          deferred.resolve content

        fail = () ->

        promise = $http
          url: [page_url, query].join '?'
          withCredentials: false

        promise.then success, fail

        deferred.promise
      ]

  $routeProvider.when '/blog',
    templateUrl: 'views.blog'
    controller: 'BlogController'
    resolve:
      posts: ['$http', '$q', ($http, $q) ->
        deferred = $q.defer()

        success = (response) ->
          posts = response.data
          deferred.resolve posts

        fail = () ->

        promise = $http
          url: post_url
          withCredentials: false

        promise.then success, fail

        deferred.promise
      ]

  $routeProvider.otherwise
    redirectTo: '/'

]
