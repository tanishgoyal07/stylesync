import 'dart:convert';

class Customer {
  final String name;
  final String imageUrl;
  final String email;
  final String password;
  final String contact;
  final int age;
  final String gender;

  Customer({
    required this.name,
    required this.imageUrl,
    required this.email,
    required this.password,
    required this.contact,
    required this.age,
    required this.gender,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      contact: map['contact'] as String,
      age: map['age'] as int,
      gender: map['gender'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'password': password,
      'contact': contact,
      'age': age,
      'gender': gender,
    };
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) => Customer.fromMap(json.decode(source));

  Customer copyWith({
    String? name,
    String? imageUrl,
    String? email,
    String? password,
    String? contact,
    int? age,
    String? gender,
  }) {
    return Customer(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      password: password ?? this.password,
      contact: contact ?? this.contact,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }
}
