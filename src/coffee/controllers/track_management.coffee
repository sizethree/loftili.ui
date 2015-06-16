TrackManagementController = ($scope, Api, resolution) ->

  console.log resolution

TrackManagementController.$inject = [
  '$scope'
  'Api'
  'resolution'
]

lft.controller 'TrackManagementController', TrackManagementController
