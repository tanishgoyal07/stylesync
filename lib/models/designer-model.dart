class Designer {
  final int id;
  final String name;
  final String imageUrl;
  final String availability;
  final String ageGroup;
  final String expertCategory;
  final String expertSubCategory;
  final String experiencedIn;
  final double averagePricing;
  final int totalCustomersServed;

  Designer({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.availability,
    required this.ageGroup,
    required this.expertCategory,
    required this.expertSubCategory,
    required this.experiencedIn,
    required this.averagePricing,
    required this.totalCustomersServed,
  });

  factory Designer.fromMap(Map<String, dynamic> map) {
    return Designer(
      id: map['id'] ?? 0,
      name: map['name'] ?? 'Unknown Designer',
      imageUrl: map['image_url'] ?? '',
      availability: map['availability'] ?? '',
      ageGroup: map['age-group'] ?? '',
      expertCategory: map['expert-category'] ?? '',
      expertSubCategory: map['expert-subCategory'] ?? '',
      experiencedIn: map['experienced-in'] ?? '',
      averagePricing: (map['averagePricing'] ?? 0).toDouble(),
      totalCustomersServed: map['total-customers-served'] ?? 0,
    );
  }
}
