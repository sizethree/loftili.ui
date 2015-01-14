_factory = () ->

  lfClientTokenList =
    templateUrl: 'directives.client_token_list'
    replace: true
    scope:
      tokens: '='
      clients: '='
      manager: '='
    link: ($scope, $element, $attrs) ->
      $scope.showing_token = false
      showing_indicies = []
      showing_indicies.push false for token in $scope.tokens

      $scope.remove = (token) ->
        success = () ->
          for t, i in $scope.tokens
            if t.id == token.id
              $scope.tokens.splice i, 1
              break
          true

        fail = () ->

        promise = $scope.manager.removeClient token
        promise.then success, fail

      $scope.showing = (index) ->
        showing_indicies[index]

      $scope.show = (index) ->
        showing_indicies[index] = true

      $scope.hide = (index) ->
        showing_indicies[index] = false

      $scope.clientById = (client_id) ->
        found_client = null
        for client in $scope.clients
          found_client = client if client.id == client_id
        found_client

      update = (new_token) ->
        $scope.tokens.push new_token

      if $scope.manager
        $scope.manager.on 'added', update

_factory.$inject = []

lft.directive 'lfClientTokenList', _factory
