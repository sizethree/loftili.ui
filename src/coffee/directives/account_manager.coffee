_factory = (Notifications, Lang, PRIVACY_LEVELS) ->

  lfAccountManager =
    replace: true
    templateUrl: 'directives.account_manager'
    scope:
      manager: '='
      user: '='
    link: ($scope, $element, $attrs) ->
      original_privacy = $scope.manager.user.privacy_level

      basic_fields = [
        'first_name'
        'last_name'
        'email'
      ]

      $scope.saving = false

      $scope.fields =
        privacy: $scope.manager.user.privacy_level or 1
        password:
          a: ''
          b: ''

      $scope.save = (property, value) ->
        wait_lang = Lang 'account.doing_update'
        wait_id = null

        success = () ->
          Notifications.remove wait_id
          success_lang = Lang 'account.update_success'
          Notifications.flash success_lang, 'success'

        fail = () ->
          Notifications.remove wait_id

        wait_id = Notifications.add wait_lang, 'info'

        promise = $scope.manager.update property, value

        promise.then success, fail

        promise

      addCallback = (field) ->
        original_value = null
        input_scope = null
        wait_lang = Lang 'account.doing_update'
        wait_id = null

        success = () ->
          input_scope.blurOut true

        fail = () ->
          input_scope.val = input_scope.value = original_value
          input_scope.blurOut true

        $scope.save[field] = (value, scope) ->
          original_value = $scope.manager.user[field]
          input_scope = scope

          if value != original_value
            $scope.saving = true
            request = $scope.save field, value
            request.then success, fail

      angular.forEach basic_fields, addCallback

      $scope.save.password = (value) ->
        success = () ->
          $scope.changing_password = false

        fail = () ->
          $scope.changing_password = true

        if $scope.fields.password.b == $scope.fields.password.a
          promise = $scope.save 'password', $scope.fields.password.b
          promise.then success, fail

      $scope.save.privacy = () ->
        success = () ->
          original_privacy = $scope.fields.privacy

        fail = () ->
          $scope.fields.privacy = original_privacy

        if $scope.fields.privacy != original_privacy
          promise = $scope.save 'privacy_level', $scope.fields.privacy
          promise.then success, fail

      $scope.changing = (state) ->
        $scope.changing_password = state

      $scope.privacy_levels = PRIVACY_LEVELS

_factory.$inject = ['Notifications', 'Lang', 'PRIVACY_LEVELS']

lft.directive 'lfAccountManager', _factory
