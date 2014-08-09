lft.directive 'lfFlashMessage', [() ->

  lfFlashMessage =
    replace: true
    templateUrl: 'directives.flash_message'
    scope:
      messages: '='
    link: ($scope, $element, $attrs) ->

]
