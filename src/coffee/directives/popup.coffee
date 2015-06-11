dPopup = (PopupManager) ->

  compile = (element, attrs, transclude) ->
    link = ($scope, $element, $attrs) ->
      delegate_destructor = null
      popup_id = PopupManager.add transclude, $scope.$parent, $element

      update = () ->
        if $scope.delegate
          PopupManager.open popup_id
        else
          PopupManager.close popup_id

      destroy = () ->
        delegate_destructor() if delegate_destructor
        PopupManager.remove popup_id

      delegate_destructor = $scope.$watch 'delegate', update

      $scope.$on '$destroy', destroy

  lfPopup =
    replace: true
    transclude: true
    templateUrl: 'directives.popup'
    scope:
      delegate: '='
    compile: compile

dPopup.$inject = [
  'PopupManager'
]

lft.directive 'lfPopup', dPopup
