dEasyInput = () ->

  dEasyInputLink = ($scope, $element, $attrs) ->
    temp_val = null
    $scope.val = $scope.value

    $scope.focus = () ->
      temp_val = $scope.val

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
    link: dEasyInputLink


dEasyInput.$inject = [
]

lft.directive 'lfEasyInput', dEasyInput
