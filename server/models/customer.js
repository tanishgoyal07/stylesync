const mongoose = require('mongoose')

const customerSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    trim: true,
  },
  password: {
    required: true,
    type: String,
  },
  contact: {
    type: String,
    required: true,
    trim: true,
  },
  gender: {
    type: String,
    required: true,
    trim: true,
  },
  age: {
    type: Number,
    required: true,
    trim: true,
  },
  imageUrl: {
    type: String,
    required: true,
    trim: true,
  },
})

const Customer = mongoose.model('customers', customerSchema)
module.exports = { Customer, customerSchema }
