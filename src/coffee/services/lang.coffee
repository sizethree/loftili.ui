LangFactory = (LANG) ->

  Lang = (context) ->
    splits = context.split '.'
    dict = LANG['en']

    while splits.length
      lvl = splits.shift()
      if dict and (dict[lvl] != undefined)
        dict = dict[lvl]
      else
        return ''

    return dict

LangFactory.$inject = ['LANG']

lft.service 'Lang', LangFactory
