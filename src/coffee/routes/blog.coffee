lft.config ['$routeProvider', ($routeProvider) ->

  url = (paths...) ->
    paths.join '/'
 
  $routeProvider.when '/blog',
    templateUrl: 'views.blog'
    controller: 'BlogController'
    title: 'blog'
    name: 'blog'
    resolve:
      posts: ['$http', '$q', 'URLS', ($http, $q, URLS) ->
        deferred = $q.defer()

        success = (response) ->
          posts = response.data
          deferred.resolve posts

        fail = () ->

        promise = $http
          url: url(URLS.blog, 'posts')
          withCredentials: false

        promise.then success, fail

        deferred.promise
      ]

  $routeProvider.when '/blog/:slug',
    templateUrl: 'views.blog'
    controller: 'BlogController'
    title: 'blog'
    name: 'blog'
    resolve:
      posts: ['$http', '$route', '$q', 'URLS', '$location', ($http, $route, $q, URLS, $location) ->
        deferred = $q.defer()
        route_params = $route.current.params
        slug_name = if route_params then route_params.slug else false

        success = (response) ->
          found_data = response.data
          has_data = angular.isArray(found_data) and found_data.length == 1

          if has_data
            deferred.resolve found_data
          else
            $location.url '/blog'

        fail = () ->

        getPost = () ->
          post_query = ['filter[name]', slug_name].join '='
          full_url = [url(URLS.blog, 'posts'), post_query].join '?'
          request = $http.get full_url
          request.then success, fail

        if !slug_name
          $location.url '/blog'
        else
          getPost()

        deferred.promise
      ]

]
