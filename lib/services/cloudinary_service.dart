import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String uploadPreset = "your-upload-preset";
  final String cloudName = "your-cloud-name";

  Future<String> uploadImage(File image) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception("Image upload failed");
    }

    final body = await response.stream.bytesToString();
    return jsonDecode(body)['secure_url'];
  }
}
