import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageService {
  static const String unsplashApiKey = "Elx6BpRN9xJxVcHhlQ54SAX6d_80VyslaM5uVVQymoI";

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
