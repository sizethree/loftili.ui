dependencies =[
  'Api/User',
  'Api/Auth',
  'Api/Device',
  'Api/Track',
  'Api/Artist',
  'Api/Playback',
  'Api/DnsRecord',
  'Api/TrackQueue',
  'Api/PasswordReset',
  'Api/DevicePermission'
]
lft.service 'Api', dependencies.concat([() ->

  aindx = 0

  Api =
    User: arguments[aindx++]
    Auth: arguments[aindx++]
    Device: arguments[aindx++]
    Track: arguments[aindx++]
    Artist: arguments[aindx++]
    Playback: arguments[aindx++]
    DnsRecord: arguments[aindx++]
    TrackQueue: arguments[aindx++]
    PasswordReset: arguments[aindx++]
    DevicePermission: arguments[aindx++]

])
