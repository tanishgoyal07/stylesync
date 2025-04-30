const express = require('express')
const router = express.Router()
const ChatMessage = require('../models/chatMessage')
const cloudinary = require('../config/cloudinary');
const multer = require('multer');
const streamifier = require('streamifier');

// Configure multer storage
const storage = multer.memoryStorage();
const upload = multer({ storage });

// Send message with optional image
router.post('/api/chats/send', upload.single('image'), async (req, res) => {
  try {
    let imageUrl = '';
    if (req.file) {
      const streamUpload = (req) => {
        return new Promise((resolve, reject) => {
          const stream = cloudinary.uploader.upload_stream((error, result) => {
            if (result) {
              resolve(result);
            } else {
              reject(error);
            }
          });
          streamifier.createReadStream(req.file.buffer).pipe(stream);
        });
      };
      const result = await streamUpload(req);
      imageUrl = result.secure_url;
    }

    const chat = new ChatMessage({
      senderId: req.body.senderId,
      senderName: req.body.senderName,
      receiverId: req.body.receiverId,
      receiverName: req.body.receiverName,
      message: req.body.message || '',
      imageUrl,
      timestamp: new Date(),
    });

    await chat.save();
    res.status(201).json(chat);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Fetch user chats
router.get('/api/chats/:userId', async (req, res) => {
  try {
    const userId = req.params.userId;
    const chats = await ChatMessage.find({
      $or: [{ senderId: userId }, { receiverId: userId }],
    }).sort({ timestamp: -1 });
    res.json(chats);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Fetch messages between two users
router.get('/api/chats/messages/:user1/:user2', async (req, res) => {
  try {
    const { user1, user2 } = req.params;
    const messages = await ChatMessage.find({
      $or: [
        { senderId: user1, receiverId: user2 },
        { senderId: user2, receiverId: user1 },
      ],
    }).sort({ timestamp: 1 });
    res.json(messages);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = router;