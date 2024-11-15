// lib/recommendation_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stylesyncapp/utils/constants.dart';

class RecommendationService {
  Future<Map<String, dynamic>> getRecommendedDesigners(Map<String, dynamic> userPreferences) async {
    try {
      print(userPreferences);
      final response = await http.post(
        Uri.parse(recommendationURL),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userPreferences),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
