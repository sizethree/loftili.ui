sm2config = (global) ->
 
  soundManager.setup
    url: '/swf/'
    preferFlash: true
    useHTML5Audio: false
    debugMode: global.LF_DEBUG == true

sm2config @
