_factory = () ->

  lfTrackList =
    replace: true
    templateUrl: 'directives.track_list'
    scope:
      tracks: '='
      manager: '='
    link: ($scope, $element, $attrs) ->

_factory.$inject = []

lft.directive 'lfTrackList', _factory
