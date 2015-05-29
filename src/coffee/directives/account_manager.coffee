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

      $scope.save = () ->
        wait_lang = Lang 'account.doing_update'
        wait_id = null
        promise = null

        success = () ->
          Notifications.remove wait_id
          success_lang = Lang 'account.update_success'
          Notifications.flash success_lang, 'success'

        fail = () ->
          Notifications.remove wait_id

        wait_id = Notifications.add wait_lang, 'info'
        (promise = $scope.manager.update $scope.manager.user).then success, fail

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
