rSignup = ($routeProvider) ->

  callbacks = []

  resolution = (URLS, $location, $q, $route, $http) ->
    deferred = $q.defer()
    content_url = [
      URLS.blog
      'pages'
    ].join '/'
    content_url += '?filter[name]=signup'

    sucess = (response) ->
      deferred.resolve
        content: response.data[0].content

    fail = () ->
      $location.url '/'

    ($http
      url: content_url).then sucess, fail

    deferred.promise


  resolution.$inject = [
    'URLS'
    '$location'
    '$q'
    '$route'
    '$http'
  ]

  SignupRoute =
    templateUrl: 'views.signup'
    controller: 'NewSignupController'
    name: 'signup'
    resolve:
      activeUser: ['Auth', (Auth) ->
        (Auth.filter 'guest')
      ],
      resolution: resolution

  $routeProvider.when '/signup', SignupRoute

rSignup.$inject = [
  '$routeProvider'
]

lft.config rSignup
