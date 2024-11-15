import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stylesyncapp/utils/constants.dart';

class AuthService {
  final String baseUrl = serverURL;

  Future<Map<String, dynamic>> createDesignerAccount(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/designers/signup'),
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

  Future<Map<String, dynamic>> createCustomerAccount(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/customers/signup'),
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

  Future<Map<String, dynamic>> designerLogin(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/designers/login'),
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

  Future<Map<String, dynamic>> customerLogin(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/customers/login'),
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
}
