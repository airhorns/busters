nodeio = require 'node.io'
busters = require '../lib/busters'

@class = class ListingUrls extends busters.Job
  input: ["http://www.autotrader.ca/a/pv/Used/Mercedes-Benz/C-Class/MERCEDESBENZ+CCLASS/?cat2=7%2c11%2c9%2c10&prv=Ontario"]
  run: (url) ->
    @getHtml url, (err, $) =>
      return @exit err if err?
      results = []
      $('.carlink').each (e) =>
        results.push "http://www.autotrader.ca#{e.attribs.href}"
      @emit results

    null

@job = new ListingUrls()
