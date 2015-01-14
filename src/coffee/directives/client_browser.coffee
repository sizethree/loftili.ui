_factory = ($timeout, Api) ->

  lfClientBrowser =
    templateUrl: 'directives.client_browser'
    replace: true
    scope:
      manager: '='
    link: ($scope, $element, $attrs) ->
      $scope.results = []
      $scope.query = {}

      debounced = null
      current_request = null

      search = () ->
        new_request = false

        success = (clients) ->
          if new_request.canceled != true
            $scope.results = clients
          else
            false

        fail = () ->

        if current_request
          current_request.canceled = true

        if $scope.query != ''
          new_request = Api.Client.query
            name: $scope.query.text

          new_request.$promise.then success, fail

          current_request = new_request
        else
          $scope.results = []

      $scope.add = (client) ->
        success = () ->
          $scope.results = []
          $scope.query.text = ''

        fail = () ->

        if $scope.manager
          promise = $scope.manager.addClient client
          promise.then success, fail
        else
          false

      $scope.keyManager = (evt) ->
        $timeout.cancel debounced
        debounced = $timeout search, 300

_factory.$inject = ['$timeout', 'Api']

lft.directive 'lfClientBrowser', _factory
