TrackManagementController = ($scope, Api, resolution) ->

  $scope.track = resolution.track
  $scope.artist = resolution.artist


TrackManagementController.$inject = [
  '$scope'
  'Api'
  'resolution'
]

lft.controller 'TrackManagementController', TrackManagementController
