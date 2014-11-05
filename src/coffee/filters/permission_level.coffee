lft.filter 'permissionLevel', ['DEVICE_PERMISSION_LEVELS', 'Lang', (DEVICE_PERMISSION_LEVELS, Lang) ->
  
  permissionLevel = (device_permission) ->
    level_name = null
    for name, val of DEVICE_PERMISSION_LEVELS
      if val == device_permission
        level_name = name
        break
    level_name

]
