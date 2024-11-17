import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stylesyncapp/utils/constants.dart';

class ImageService {
  Future<List<String>> fetchImagesForCategory(String category) async {
    final url =
        "https://api.unsplash.com/search/photos?query=$category+clothing&per_page=5&client_id=$unsplashApiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;
      return results.map<String>((item) => item['urls']['regular'] as String).toList();
    } else {
      return [];
    }
  }
}
