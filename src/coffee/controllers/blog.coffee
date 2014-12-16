lft.controller 'BlogController', ['$scope', '$route', 'posts', ($scope, $route, posts) ->

  current_route = $route.current
  current_params = current_route.params

  $scope.has_slug = current_params and angular.isString current_params.slug
  $scope.posts = posts

]
