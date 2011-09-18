mongoose = require 'mongoose'
nodeio = require 'node.io'

mongoose.connect 'mongodb://localhost/busters'

ListingSchema = new mongoose.Schema
  year: Number
  brand: String
  model: String
  trim: String
  drive: String
  status: String
  mileage: Number
  body: String
  exteriorcolour: String
  price: Number

exports.Listing = mongoose.model 'Listing', ListingSchema

exports.Job = class Job extends nodeio.JobProto
  constructor: ->
    super
    this.handleSpecialIO()

  extend: (options, methods) ->
    if typeof methods is "undefined"
      methods = options
      options = {}

    class Child extends @constructor
      @::[k] = v for k, v of methods

    options[k] = v for k, v of @options when !options[k]

    new Child(options)
