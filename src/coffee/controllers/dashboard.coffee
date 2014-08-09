lft.controller 'DashboardController', ['$scope', 'Auth', ($scope, Auth) ->

  $scope.logout = () ->
    Auth.logout()

]
