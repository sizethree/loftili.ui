lft.directive 'lfEditFieldInput', ['$rootScope', ($rootScope) ->
  
  lfEditFieldInput =
    scope: false
    require: ['^lfEditField', 'ngModel']
    link: ($scope, $element, $attrs, controllers) ->
      editField = controllers[0]
      model = controllers[1]

      keyman = (evt) ->
        is_save = evt.keyCode == 13
        if is_save or evt.keyCode == 27
          editField.close is_save, model.$modelValue
          $rootScope.$digest()

      focus = () ->
        $element[0].focus()
        model.$modelValue

      editField.add focus

      $element.on 'keyup', keyman
      $scope.$on 'openedEditField', focus

]
