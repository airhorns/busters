coffee = require 'coffee-script'
busters = require '../lib/busters'
ent = require 'ent'

@class = class ListingSearch extends busters.Job
  RCS_RE = /rcs=(\d+)/

  input: ["http://www.autotrader.ca/a/pv/Used/Mercedes-Benz/C-Class/MERCEDESBENZ+CCLASS/?cat2=7%2c11%2c9%2c10&prv=Ontario"]
  run: (url) ->
    urls = [url]
    @getHtml url, (err, $) =>
      lastLink = $('div.Pager a').last()
      href = "http://www.autotrader.ca#{ent.decode lastLink.attribs.href}"

      if match = RCS_RE.exec(href)
        lastRCS = parseInt(match[1], 10)
      else
        return @fail "Couldn't get the final RCS number!"

      for rcs in [25..lastRCS] by 25
        urls.push href.replace RCS_RE, "rcs=#{rcs}"

      @emit urls

    null

@job = new ListingSearch()
