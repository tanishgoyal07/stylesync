const express = require("express");
const mongoose = require("mongoose");
const http = require("http");
const { Server } = require("socket.io");
const cors = require("cors");

const customerRouter = require("./routes/customer");
const designerRouter = require("./routes/designer");
const logoutRouter = require("./routes/logoutRoutes");
const productRouter = require("./routes/product");
const chatRoutes = require('./routes/chatMessage');
const ChatMessage = require('./models/chatMessage');

const PORT = process.env.PORT || 3000;
const DB = "mongodb+srv://aryabagla2003:arya1234@cluster0.btyhj.mongodb.net/users?retryWrites=true&w=majority&appName=Cluster0";

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*", // allow all origins; restrict this in production
    methods: ["GET", "POST"]
  }
});

app.use(cors());
app.use(express.json());
app.use(customerRouter);
app.use(designerRouter);
app.use(logoutRouter);
app.use(productRouter);
app.use(chatRoutes);

// Socket.IO Logic
io.on("connection", (socket) => {
  console.log("New client connected:", socket.id);

  // Join user to their unique room
  socket.on("join", (userId) => {
    socket.join(userId);
    console.log(`User ${userId} joined their room`);
  });

  // Handle sending message
  socket.on("sendMessage", async (data) => {
    const { senderId, senderName, receiverId, receiverName, message, imageUrl , timestamp } = data;

    // Save message to DB
    const newMessage = new ChatMessage({
      senderId,
      senderName,
      receiverId,
      receiverName,
      message,
      imageUrl,
      timestamp,
    });
    await newMessage.save();

    // Emit to receiver in real-time
    io.to(receiverId).emit("newMessage", newMessage);
  });

  socket.on("disconnect", () => {
    console.log("Client disconnected:", socket.id);
  });
});

// MongoDB Connection
mongoose
  .connect(DB)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log(err));

app.get("/", (req, res) => {
  res.json({ message: "Hello world from backend" });
});

// Start server
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
