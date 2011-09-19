nodeio = require 'node.io'
coffee = require 'coffee-script'
busters = require '../lib/busters'

@class = class ListingUrls extends busters.Job
  input: ["http://www.autotrader.ca/a/pv/new-used/all/all/MERCEDESBENZ+CCLASS/?lloc=Montreal&cty=Montr%C3%A9al&prv=Quebec&ctr=Canada&vpt=45.2805939614465%2c-73.9935797136234%2c45.7441213336412%2c-73.115225875408%2c&prx=100&"]
  run: (url) ->
    @getHtml url, (err, $) =>
      return @exit err if err?
      results = []
      $('.carlink').each (e) =>
        results.push "http://www.autotrader.ca#{busters.linkify e.attribs.href}"
      @emit results

    null

@job = new ListingUrls()
