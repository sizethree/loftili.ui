lft.directive 'lfTrack', [() ->

  lfTrack =
    replace: true
    templateUrl: 'directives.track'
    scope:
      track: '='
    link: ($scope, $elements, $attrs) ->

]
