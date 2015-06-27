cSignup = ($scope, resolution) ->

  $scope.content = resolution.content

cSignup.$inject = [
  '$scope',
  'resolution'
]

lft.controller 'NewSignupController', cSignup
