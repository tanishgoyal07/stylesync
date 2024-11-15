import 'dart:convert';

class Designer {
  final String name;
  final String imageUrl;
  final String availability;
  final String ageGroup;
  final String expertCategory;
  final String expertSubCategory;
  final String experiencedIn;
  final int averagePricing;
  final int totalCustomersServed;
  final String email;
  final String password;

  Designer({
    required this.name,
    required this.imageUrl,
    required this.availability,
    required this.ageGroup,
    required this.expertCategory,
    required this.expertSubCategory,
    required this.experiencedIn,
    required this.averagePricing,
    required this.totalCustomersServed,
    required this.email,
    required this.password,
  });

  factory Designer.fromMap(Map<String, dynamic> map) {
    return Designer(
      name: map['name'] as String? ?? 'Unknown',
      imageUrl: map['imageUrl'] as String? ?? '',
      availability: map['availability'] as String? ?? 'Not Available',
      ageGroup: map['ageGroup'] as String? ?? 'Not Specified',
      expertCategory: map['expertCategory'] as String? ?? 'General',
      expertSubCategory: map['expertSubCategory'] as String? ?? 'N/A',
      experiencedIn: map['experiencedIn'] as String? ?? 'N/A',
      averagePricing: map['averagePricing'] as int? ?? 0,
      totalCustomersServed: map['totalCustomersServed'] as int? ?? 0,
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
      'availability': availability,
      'ageGroup': ageGroup,
      'expertCategory': expertCategory,
      'expertSubCategory': expertSubCategory,
      'experiencedIn': experiencedIn,
      'averagePricing': averagePricing,
      'totalCustomersServed': totalCustomersServed,
      'email': email,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());

  factory Designer.fromJson(String source) =>
      Designer.fromMap(json.decode(source));
}
