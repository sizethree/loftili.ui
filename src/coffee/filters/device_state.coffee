lft.filter 'deviceState', ['DEVICE_STATES', (DEVICE_STATES) ->
  
  deviceState = (play_state) ->
    if /playing/i.test play_state
      "playing"
    else if /stopped/i.test play_state
      "stopped"
    else if /errored/i.test play_state
      "errored"

]
