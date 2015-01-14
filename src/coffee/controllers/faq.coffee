_factory = ($scope, content) ->

  $scope.content = content

_factory.$inject = ['$scope', 'content']

lft.controller 'FaqController', _factory
