lft.config ['$routeProvider', ($routeProvider) ->

  to_i = (num) -> parseInt num, 10

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

  $routeProvider.when '/blog/pages/:id',
    templateUrl: 'views.blog',
    controller: 'BlogController'
    name: 'blog'
    resolve:
      posts: ['$http', '$route', '$q', 'URLS', '$location', ($http, $route, $q, URLS, $location) ->
        deferred = $q.defer()
        current_route = $route.current
        route_params = current_route.params
        page_id = if route_params then to_i route_params.id else false

        fail = () ->
          $location.url '/blog'

        success = (response) ->
          has_posts = angular.isArray(response.data) and response.data.length > 0
          if has_posts
            deferred.resolve response.data
          else
            fail()

        getPosts = () ->
          promise = $http
            url: url URLS.blog, 'posts'
            params:
              page: page_id
            withCredentials: false
          promise.then success, fail

        if page_id
          getPosts()
        else
          fail()

        deferred.promise
      ]

  $routeProvider.when '/blog/:slug',
    templateUrl: 'views.blog'
    controller: 'BlogController'
    name: 'blog'
    title: 'none'
    resolve:
      posts: ['$http', '$route', '$q', 'URLS', '$location', ($http, $route, $q, URLS, $location) ->
        deferred = $q.defer()
        current_route = $route.current
        route_params = current_route.params
        slug_name = if route_params then route_params.slug else false

        success = (response) ->
          found_data = response.data
          has_data = angular.isArray(found_data) and found_data.length == 1
          current_route.$$route.title = found_data[0].title

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
