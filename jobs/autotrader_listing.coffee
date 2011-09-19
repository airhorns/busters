nodeio = require 'node.io'
coffee = require 'coffee-script'
busters = require '../lib/busters'

@class = class Listing extends busters.Job
  input: ["http://www.autotrader.ca/a/Mercedes-Benz/C-Class/MILLGROVE/Ontario/19_4430793_/"]
  run: (url) ->
    @getHtml url, (err, $) =>
      return @exit err if err?
      listingProperties = {}

      $('div[itemtype="http://schema.org/Product"] table td').each (e) =>
        return unless e.fulltext.length

        # Support rows which use a span
        # <td style="width: 50%; ">
        #   <strong>Make:</strong><span itemprop="brand">Mercedes-Benz</span>
        # </td>
        # and Support rows which use just a strong
        # <td style="width: 50%; ">
        #   <strong>Year: </strong>2011
        # </td>
        try
          itemPropSpan = $('span', e)
          key = itemPropSpan.attribs.itemprop
          value = itemPropSpan.fulltext
        catch error
          try
            strongSpan = $('strong', e)
            key = strongSpan.text.replace(/:|\s/g, '')
            value = e.text
          catch strongError
            console.log e.innerHTML
            return @exit strongError

        key = key.toLowerCase()
        switch key
          when 'mileage'
            value = value.replace(/[^0-9]/g, '')
          when "style/trim", "style", "trim"
            key = "trim"

        listingProperties[key] = value


      # Retrieve the price from
      # <span id="ctl00_PageContentPlaceHolder_financing_lblPriceValue" class="loadfinancing_green_text">$61,999</span>
      price = $('#ctl00_PageContentPlaceHolder_financing_lblPriceValue').fulltext.replace(/\$|,/g, '')
      listingProperties.price = price

      @assert(listingProperties.price).isNumeric()
      #@assert(listingProperties.mileage).isNumeric()
      @assert(listingProperties.year).isNumeric()
      @assert(listingProperties.brand).notEmpty()
      @assert(listingProperties.model).notEmpty()
      @emit listingProperties
    null

@job = new Listing()
