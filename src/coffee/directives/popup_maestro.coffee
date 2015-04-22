dPopupMaestro = (PopupManager) ->

  link = ($scope, $element, $attrs) ->

  lfPopupMaestro =
    replace: true
    templateUrl: 'directives.popup_maestro'
    controller: PopupManager.Maestro
    link: link


dPopupMaestro.$inject = [
  'PopupManager'
]

lft.directive 'lfPopupMaestro', dPopupMaestro
