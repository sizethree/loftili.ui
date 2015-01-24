_factory = ($scope, token, content) ->

  $scope.token = token
  $scope.content = content
  
_factory.$inject = ['$scope', 'token', 'content']

lft.controller 'SignupController', _factory
