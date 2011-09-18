mongoose = require 'mongoose'

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
