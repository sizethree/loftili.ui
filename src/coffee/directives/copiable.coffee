dCopiable = ($rootScope, Notifications, Lang) ->

  dCopiableLink = ($scope, $element, $attrs) ->
    client = new ZeroClipboard $element[0]

    doCopy = (event) ->
      copy_data = $attrs['copydata']
      event.clipboardData.setData 'text/plain', copy_data

    afterCopy = () ->
      copy_lang = Lang 'copied_to_clipboard'
      Notifications.flash.info copy_lang
      $rootScope.$digest()

    client.on 'ready', () ->
      client.on 'copy', doCopy
      client.on 'afterCopy', afterCopy
    

  lfCopiable =
    replace: false
    link: dCopiableLink

dCopiable.$inject = [
  '$rootScope'
  'Notifications'
  'Lang'
]

lft.directive 'lfCopiable', dCopiable
