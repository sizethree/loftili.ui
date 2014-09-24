dependencies =[
  'Api/User',
  'Api/Auth',
  'Api/Device',
  'Api/Track',
  'Api/Artist',
  'Api/DevicePermission',
  'Api/DnsRecord',
  'Api/Playback',
  'Api/PasswordReset'
]
lft.service 'Api', dependencies.concat([() ->

  Api =
    User: arguments[0]
    Auth: arguments[1]
    Device: arguments[2]
    Track: arguments[3]
    Artist: arguments[4]
    DevicePermission: arguments[5]
    DnsRecord: arguments[6]
    Playback: arguments[7]
    PasswordReset: arguments[8]

])
