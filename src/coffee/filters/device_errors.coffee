_factory = (Lang) ->

  deviceErrors = (error_text) ->
    clean_text = error_text.replace /[^\w]/gi, '_'
    lang_path = ['device', 'errors', clean_text].join('.')
    Lang lang_path

_factory.$inject = ['Lang']

lft.filter 'deviceErrors', _factory
