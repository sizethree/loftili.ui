dEasyInput = ($timeout) ->

  dEasyInputLink = ($scope, $element, $attrs) ->
    $scope.values =
      mask: $scope.value
      temp: null

    $scope.type = $attrs['type']
    is_saving = false

    revert = () ->
      $scope.focused = false
      $scope.values.mask = $scope.values.temp

    $scope.save = () ->
      can_save = angular.isFunction $scope.finish

      success = () ->
        $scope.focused = false

      if can_save
        is_saving = true
        result = $scope.finish $scope.values.mask, $scope, $element

        if angular.isFunction result.then
          result.then success, revert

    $scope.cancel = () ->

    $scope.onBlur = () ->
      blur = () ->
        revert() if !is_saving

      $timeout blur, 100

    $scope.onFocus = () ->
      $scope.focused = true
      $scope.values.temp = $scope.values.mask

    $scope.blurOut = () ->
      input_el = $element.find 'input'
      input_el[0].blur()
      $scope.focused = false

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
