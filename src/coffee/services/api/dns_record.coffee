DnsRecordFactory = ($resource, API_HOME) ->

  DnsRecord = $resource [API_HOME, 'dns'].join('/')

lft.service 'Api/DnsRecord', [
  '$resource',
  'API_HOME',
  DnsRecordFactory
]
