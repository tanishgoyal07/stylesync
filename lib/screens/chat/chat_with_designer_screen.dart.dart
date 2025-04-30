import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stylesyncapp/models/chat_message.dart';
import 'package:stylesyncapp/services/chat_service.dart';
import 'package:stylesyncapp/utils/constants.dart';

class ChatWithDesignerScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;
  final String otherUserId;
  final String otherUserName;

  const ChatWithDesignerScreen({
    Key? key,
    required this.currentUserId,
    required this.currentUserName,
    required this.otherUserId,
    required this.otherUserName,
  }) : super(key: key);

  @override
  State<ChatWithDesignerScreen> createState() => _ChatWithDesignerScreenState();
}

class _ChatWithDesignerScreenState extends State<ChatWithDesignerScreen> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Set<String> _messageIds = {}; // To track unique messages
  List<ChatMessage> _messages = [];
  File? _imageFile;

  void _initSocket() {
    socket = IO.io(serverURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected');
      socket.emit('join', widget.currentUserId);
    });

    // Remove any existing listeners to prevent duplicates
    socket.off('newMessage');

    socket.on('newMessage', (data) {
      final msg = ChatMessage.fromJson(data);

      if (!_messageIds.contains(msg.id) &&
          ((msg.senderId == widget.otherUserId &&
                  msg.receiverId == widget.currentUserId) ||
              (msg.senderId == widget.currentUserId &&
                  msg.receiverId == widget.otherUserId))) {
        setState(() {
          _messages.add(msg);
          _messageIds.add(msg.id);
        });
        _scrollToBottom();
      }
    });

    socket.onDisconnect((_) => print('Socket disconnected'));
  }

  void _loadInitialMessages() async {
    final msgs = await ChatService.fetchMessages(
        widget.currentUserId, widget.otherUserId);

    setState(() {
      _messages = [];
      _messageIds.clear();

      for (var msg in msgs) {
        if (!_messageIds.contains(msg.id)) {
          _messages.add(msg);
          _messageIds.add(msg.id);
        }
      }
    });

    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty && _imageFile == null) return;

    final newMessage = ChatMessage(
      id: '',
      senderId: widget.currentUserId,
      senderName: widget.currentUserName,
      receiverId: widget.otherUserId,
      receiverName: widget.otherUserName,
      message: _controller.text.trim(),
      imageUrl: null,
      timestamp: DateTime.now(),
    );

    try {
      final sentMsg =
          await ChatService.sendMessage(newMessage, imageFile: _imageFile);
      setState(() {
        if (!_messageIds.contains(sentMsg.id)) {
          _messages.add(sentMsg);
          _messageIds.add(sentMsg.id);
        }
        _controller.clear();
        _imageFile = null;
      });

      socket.emit('sendMessage', sentMsg.toJson());
      _scrollToBottom();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initSocket();
    _loadInitialMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    socket.dispose();
    super.dispose();
  }

  Widget _buildMessage(ChatMessage msg) {
    final isMe = msg.senderId == widget.currentUserId;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (msg.imageUrl != null && msg.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    msg.imageUrl!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text("Failed to load image"),
                  ),
                ),
              ),
            if (msg.message.isNotEmpty)
              Text(
                msg.message,
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.otherUserName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          if (_imageFile != null)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => setState(() => _imageFile = null),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: "Type your message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
