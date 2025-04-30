import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stylesyncapp/models/chat_message.dart';
import 'package:stylesyncapp/screens/chat/chat_with_designer_screen.dart.dart';
import 'package:stylesyncapp/services/chat_service.dart';
import 'package:stylesyncapp/utils/constants.dart';
import 'package:stylesyncapp/widgets/chat_tile.dart';

class ChatsScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;

  const ChatsScreen({
    Key? key,
    required this.currentUserId,
    required this.currentUserName,
  }) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late IO.Socket socket;
  Map<String, ChatMessage> latestMessages = {};

  @override
  void initState() {
    super.initState();
    _initializeSocket();
    _loadChats();
  }

  void _initializeSocket() {
    socket = IO.io(serverURL, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Socket connected to chat list screen');
      socket.emit('join', widget.currentUserId);
    });

    socket.on('newMessage', (data) {
      final msg = ChatMessage.fromJson(data);

      if (msg.senderId == widget.currentUserId || msg.receiverId == widget.currentUserId) {
        final otherId = widget.currentUserId == msg.senderId
            ? msg.receiverId
            : msg.senderId;

        setState(() {
          latestMessages[otherId] = msg;
        });
      }
    });

    socket.onDisconnect((_) => print('Socket disconnected from chat list'));
  }

  void _loadChats() async {
    final chats = await ChatService.fetchUserChats(widget.currentUserId);
    final uniqueMap = <String, ChatMessage>{};

    for (var chat in chats) {
      final otherId = widget.currentUserId == chat.senderId
          ? chat.receiverId
          : chat.senderId;

      if (!uniqueMap.containsKey(otherId) ||
          chat.timestamp.isAfter(uniqueMap[otherId]!.timestamp)) {
        uniqueMap[otherId] = chat;
      }
    }

    setState(() {
      latestMessages = uniqueMap;
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatsList = latestMessages.entries.toList()
      ..sort((a, b) => b.value.timestamp.compareTo(a.value.timestamp));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("My Chats", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8D6E63),
      ),
      body: chatsList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatsList.length,
              itemBuilder: (context, index) {
                final chat = chatsList[index].value;
                final otherId = widget.currentUserId == chat.senderId
                    ? chat.receiverId
                    : chat.senderId;
                final otherName = widget.currentUserId == chat.senderId
                    ? chat.receiverName
                    : chat.senderName;

                return ChatTile(
                  chat: chat,
                  currentUserId: widget.currentUserId,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatWithDesignerScreen(
                          currentUserId: widget.currentUserId,
                          currentUserName: widget.currentUserName,
                          otherUserId: otherId,
                          otherUserName: otherName,
                        ),
                      ),
                    );
                    _loadChats(); // refresh after returning from chat
                  },
                );
              },
            ),
    );
  }
}
