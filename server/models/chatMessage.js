const mongoose = require('mongoose')

const chatMessageSchema = new mongoose.Schema({
  senderId: {
    type: String,
    required: true
  },
  senderName: {
    type: String,
    required: true
  },
  receiverId: {
    type: String,
    required: true
  },
  receiverName: {
    type: String,
    required: true
  },
  message: { type: String, default: '' },
  imageUrl: { type: String, default: '' },
  timestamp: {
    type: Date,
    default: Date.now
  },
})

module.exports = mongoose.model('ChatMessage', chatMessageSchema)