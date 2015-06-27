_factory = ($routeProvider) ->

  url = (paths...) ->
    paths.join '/'

  post_filter = (id) ->
    ["filter[p]=", id].join ''

  $routeProvider.when '/join/:token',
    templateUrl: 'views.invitation'
    controller: 'SignupController'
    name: 'join'
    title: 'none'
    resolve:
      token: ['$route', '$q', '$location', 'Api', ($route, $q, $location, Api) ->
        deferred = $q.defer()

        current_route = $route.current
        token = current_route and current_route.params.token

        success = (response) ->
          if !angular.isArray(response) or response.length < 1
            $location.url '/'
          else
            deferred.resolve response[0]

        fail = () ->
          deferred.reject()

        request = Api.Invitation.query
          token: token

        request.$promise.then success, fail

        deferred.promise
      ]
      content: ['$http', '$q', 'URLS', ($http, $q, URLS) ->
        deferred = $q.defer()
        query = post_filter 297

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


_factory.$inject = ['$routeProvider']

lft.config _factory
