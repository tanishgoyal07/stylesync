import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stylesyncapp/utils/constants.dart';
import '../models/chat_message.dart';

class ChatService {
  static Future<List<ChatMessage>> fetchUserChats(String userId) async {
    final res = await http.get(Uri.parse('$baseUrl/$userId'));
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  static Future<List<ChatMessage>> fetchMessages(
      String user1, String user2) async {
    final res = await http.get(Uri.parse('$baseUrl/messages/$user1/$user2'));
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      return data.map((json) => ChatMessage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<ChatMessage> sendMessage(ChatMessage message,
      {File? imageFile}) async {
    var uri = Uri.parse('$baseUrl/send');
    var request = http.MultipartRequest('POST', uri);

    request.fields['senderId'] = message.senderId;
    request.fields['senderName'] = message.senderName;
    request.fields['receiverId'] = message.receiverId;
    request.fields['receiverName'] = message.receiverName;
    request.fields['message'] = message.message;
    request.fields['timestamp'] = message.timestamp.toIso8601String();

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    var streamedResponse = await request.send();
    final res = await http.Response.fromStream(streamedResponse);

    if (res.statusCode == 201) {
      final data = json.decode(res.body);
      return ChatMessage.fromJson(
          data); // returns the full object including imageUrl
    } else {
      throw Exception('Failed to send message');
    }
  }
}
