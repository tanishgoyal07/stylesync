import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  // Save designer data
  static Future<void> saveDesignerData(Map<String, dynamic> designerData) async {
    final prefs = await SharedPreferences.getInstance();
    String designerDataJson = json.encode(designerData);
    await prefs.setString('designerData', designerDataJson);
  }

  // Save customer data
  static Future<void> saveCustomerData(Map<String, dynamic> customerData) async {
    final prefs = await SharedPreferences.getInstance();
    String customerDataJson = json.encode(customerData);
    print(customerDataJson);
    await prefs.setString('customerData', customerDataJson);
  }

  // Retrieve designer data
  static Future<Map<String, dynamic>?> getDesignerData() async {
    final prefs = await SharedPreferences.getInstance();
    final designerData = prefs.getString('designerData');
    if (designerData != null && designerData.isNotEmpty) {
      return json.decode(designerData);
    }
    return null;
  }

  // Retrieve customer data
  static Future<Map<String, dynamic>?> getCustomerData() async {
    final prefs = await SharedPreferences.getInstance();
    final customerData = prefs.getString('customerData');
    if (customerData != null && customerData.isNotEmpty) {
      return json.decode(customerData);
    }
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('designerData') || prefs.containsKey('customerData');
  }

  // Clear user data on logout
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
