lft.directive 'lfTrackList', [() ->

  lfTrackList =
    replace: true
    templateUrl: 'directives.track_list'
    scope:
      tracks: '='
    link: ($scope, $element, $attrs) ->

]
