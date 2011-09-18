nodeio = require 'node.io'
coffee = require 'coffee-script'
busters = require '../lib/busters'

@class = class SaveToDB extends busters.Job
  input: [{"year":"2011","brand":"Mercedes-Benz","model":"C63 AMG","trim":"Affalterbach Edition","drive":"RWD","status":"Used","mileage":"27","body":"Sedan","exteriorcolour":"Not Specified","price":"117000"}]
  run: (attributes) ->
    for k in ['year', 'mileage', 'price']
      attributes[k] = parseInt(attributes[k], 10) if attributes[k]

    listing = new busters.Listing(attributes)
    listing.save (err) =>
      if err
        @fail err
      else
        @emit listing
    null

@job = new SaveToDB()
