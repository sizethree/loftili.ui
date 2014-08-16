lft.directive 'lfEditField', [() ->

  class EditField

    constructor: (@scope) ->
      @inputs = []

    save: (value) ->
      if angular.isFunction @scope.save
        @scope.save @scope.property, value

    revert: (value) ->
      if angular.isFunction @scope.revert
        @scope.revert @scope.property, value

    close: (save, final_value) ->
      @scope.editing = false
      if save
        @save(final_value)
      else
        @revert(@original_value)
        
    focus: () ->
      @original_value = @inputs[0]()

    add: (focus_fn) ->
      if angular.isFunction focus_fn
        @inputs.push focus_fn

  EditField.$inject = ['$scope']

  lfEditField =
    replace: true
    transclude: true
    templateUrl: 'directives.edit_field'
    scope:
      save: '='
      revert: '='
      property: '='
    controller: EditField
    link: ($scope, $element, $attrs, editField) ->
      $scope.editing = false

      start = () ->
        $scope.editing = true
        editField.focus()

      $scope.toggle = () ->
        unless $scope.editing
          start()

]
