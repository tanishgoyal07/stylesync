import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  // Save designer data
  static Future<void> saveDesignerData(
      Map<String, dynamic> designerData) async {
    final prefs = await SharedPreferences.getInstance();
    String designerDataJson = json.encode(designerData);
    await prefs.setString('designerData', designerDataJson);
  }

  // Save customer data
  static Future<void> saveCustomerData(
      Map<String, dynamic> customerData) async {
    final prefs = await SharedPreferences.getInstance();
    String customerDataJson = json.encode(customerData);
    await prefs.setString('customerData', customerDataJson);
  }

  // Retrieve designer data
  static Future<Map<String, dynamic>?> getDesignerData() async {
    final prefs = await SharedPreferences.getInstance();
    final designerData = prefs.getString('designerData');

    // Ensure the retrieved data is not null before decoding
    if (designerData != null && designerData.isNotEmpty) {
      return json.decode(designerData);
    }
    return null;
  }

// Retrieve customer data
  static Future<Map<String, dynamic>?> getCustomerData() async {
    print("Fetching customer data from SharedPreferences...");
    final prefs = await SharedPreferences.getInstance();
    final customerData = prefs.getString('customerData');

    if (customerData != null && customerData.isNotEmpty) {
      print("Customer data found: $customerData");
      return json.decode(customerData);
    } else {
      print("No customer data found in SharedPreferences.");
    }
    return null;
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('email');
  }

  // Remove user data on logout
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
