dTrackList = () ->

  dTrackListLink = ($scope, $element, $attrs) ->

  lfTrackList =
    replace: true
    templateUrl: 'directives.track_list'
    scope:
      tracks: '='
      manager: '='
    link: dTrackListLink

dTrackList.$inject = [
]

lft.directive 'lfTrackList', dTrackList
