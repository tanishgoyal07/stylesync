// lib/widgets/chat_tile.dart
import 'package:flutter/material.dart';
import 'package:stylesyncapp/models/chat_message.dart';

class ChatTile extends StatelessWidget {
  final ChatMessage chat;
  final String currentUserId;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.chat,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSender = chat.senderId == currentUserId;
    final otherUserName = isSender ? chat.receiverName : chat.senderName;

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(otherUserName),
      subtitle: Text(
        chat.imageUrl != null && chat.imageUrl!.isNotEmpty
            ? '📷 Image'
            : chat.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        "${chat.timestamp.hour.toString().padLeft(2, '0')}:${chat.timestamp.minute.toString().padLeft(2, '0')}",
      ),
      onTap: onTap,
    );
  }
}
