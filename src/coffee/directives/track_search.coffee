lft.directive 'lfTrackSearch', ['$timeout', 'Api', ($timeout, Api) ->

  Track = Api.Track
  isArr = angular.isArray

  lfTrackSearch =
    replace: true
    templateUrl: 'directives.track_search'
    scope: {}
    link: ($scope, $element, $attrs) ->
      last_val = null
      bounce_timeout = null
      url_test = /^(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/

      display = (tracks) ->
        $scope.results = if isArr tracks then tracks else [tracks]

      search = () ->
        if url_test.test last_val
          web()
        else
          library()

      web = () ->
        track_promise = Track.scout
          url: btoa(last_val)
        track_promise.$promise.then display

      library = () ->
        track_promise = Track.search
          q: last_val
        track_promise.$promise.then display

      $scope.search = (evt) ->
        last_val = evt.target.value
        if bounce_timeout
          $timeout.cancel bounce_timeout

        if last_val != ''
          bounce_timeout = $timeout search, 200
        else
          $scope.results = []

]
