dEasyInput = ($timeout) ->

  dEasyInputLink = ($scope, $element, $attrs) ->
    $scope.values =
      mask: $scope.value
      temp: null

    $scope.type = $attrs['type']
    is_saving = false
    should_revert = true

    $scope.cancel = () ->
      should_revert = true
      revert()

    revert = () ->
      $scope.values.mask = $scope.values.temp

    $scope.save = () ->
      can_save = angular.isFunction $scope.finish
      should_revert = true

      success = () ->
        should_revert = false
        $scope.focused = false
        is_saving = false

      if can_save
        is_saving = true
        result = $scope.finish $scope.values.mask, $scope, $element

        if angular.isFunction result.then
          result.then success, revert

    $scope.cancel = () ->

    $scope.onBlur = () ->
      blur = () ->
        $scope.focused = false
        revert() if should_revert

      $timeout blur, 300

    $scope.onFocus = () ->
      should_revert = true
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
