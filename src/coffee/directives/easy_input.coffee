dEasyInput = ($timeout) ->

  dEasyInputLink = ($scope, $element, $attrs) ->
    temp_val = null
    $scope.val = $scope.value
    $scope.type = $attrs['type']

    $scope.save = () ->
      can_save = angular.isFunction $scope.finish
      if can_save
        $scope.finish $scope.val, $scope, $element

    $scope.cancel = () ->

    $scope.focus = () ->
      temp_val = $scope.val

    $scope.onBlur = () ->
      blur = () ->
        $scope.focused = false

      $timeout blur, 50

    $scope.onFocus = () ->
      $scope.focused = true

    $scope.blurOut = () ->
      input_el = $element.find 'input'
      input_el[0].blur()

    $scope.keyUp = (event) ->
      is_save = event.keyCode == 13
      can_save = angular.isFunction $scope.finish

      if is_save and can_save
        $scope.finish $scope.val, $scope, $element

  lfEasyInput =
    restrict: 'A'
    templateUrl: 'directives.easy_input'
    replace: false
    scope:
      finish: '='
      value: '='
      type: '&'
    link: dEasyInputLink


dEasyInput.$inject = [
  '$timeout'
]

lft.directive 'lfEasyInput', dEasyInput
