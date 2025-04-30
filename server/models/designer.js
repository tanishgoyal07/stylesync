const mongoose = require('mongoose')
const { v4: uuidv4 } = require('uuid');

const designerSchema = mongoose.Schema({
  id: {
    type: String,
    required: true,
    unique: true,
    default: () => uuidv4(),
  },
  name: {
    type: String,
    required: true,
    trim: true,
  },
  imageUrl: {
    type: String,
    required: true,
    trim: true,
  },
  availability: {
    type: String,
    required: true,
    trim: true,
  },
  ageGroup: {
    type: String,
    required: true,
    trim: true,
  },
  expertCategory: { type: String, required: true, trim: true },
  expertSubCategory: { type: String, required: true, trim: true },
  experiencedIn: { type: String, required: true, trim: true },
  averagePricing: { type: Number, required: true },
  totalCustomersServed: { type: Number, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
})

const Designer = mongoose.model('designers', designerSchema)
module.exports = { Designer }
