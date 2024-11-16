import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stylesyncapp/models/product-model.dart';
import 'package:stylesyncapp/utils/constants.dart';

class ProductService {
  final String baseUrl = serverURL;

  Future<Map<String, dynamic>> uploadDesigns(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/upload-design'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          jsonDecode(response.body)['error'] ?? 'Something went wrong');
    }
  }

  Future<List<Product>> fetchUploadedDesigns() async {
    final response = await http.get(Uri.parse('$baseUrl/api/designs'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load designs');
    }
  }
}
