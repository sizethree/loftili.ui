lft.service 'Analaytics', ['GA_ID', (GA_ID) ->

  ga 'create', GA_ID, 'auto'
  ga 'send', 'pageview'

  Analaytics =

    track: (path, title) ->
      ga 'send', 'pageview',
        page: path,
        title: title
    
    log: () ->

    event: (category, action, data) ->
      ga 'send', 'event', category, action, data

  Analaytics

]
