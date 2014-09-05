DnsRecordFactory = ['$resource', 'URLS', ($resource, URLS) ->

  DnsRecord = $resource [URLS.api, 'dns'].join('/')

]

lft.service 'Api/DnsRecord', DnsRecordFactory
