_factory = ($timeout, Auth, Api) ->

  BOUNCE_TIME = 400
  Track = Api.Track
  isArr = angular.isArray

  lfTrackSearch =
    replace: true
    templateUrl: 'directives.track_search'
    scope: {}
    link: ($scope, $element, $attrs) ->
      last_val = null
      bounce_timeout = null
      flag_remove_timeout = null
      url_test = /^(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/
      $scope.searching = false
      $scope.query =
        val: ''

      display = (tracks) ->
        $scope.searching = false
        $scope.results = if isArr tracks then tracks else [tracks]

      search = () ->
        $scope.searching = true
        library()

      library = () ->
        $scope.searching = true
        (track_promise = Track.search
          q: last_val).$promise.then display

      $scope.search = (evt) ->
        last_val = evt.target.value
        if bounce_timeout
          $timeout.cancel bounce_timeout

        if last_val != ''
          bounce_timeout = $timeout search, BOUNCE_TIME
        else
          $scope.results = []

      $scope.add = (track) ->
        current_user = Auth.user()
        promise = Api.User.addTrack
          id: current_user.id
          track: track.id

        success = (new_track) ->
          $scope.results = []
          $scope.$emit 'track:added', new_track

        fail = () ->

        promise.$promise.then success, fail

      closed = () ->
        $scope.searching = false
        $scope.query.val = ''

      $scope.$on 'closed', closed

_factory.$inject = ['$timeout', 'Auth', 'Api']

lft.directive 'lfTrackSearch', _factory
