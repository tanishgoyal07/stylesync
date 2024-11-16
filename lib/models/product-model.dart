class Product {
  final String designerName;
  final String category;
  final String articleType;
  final String description;
  final double price;
  final List<String> imageUrls;
  final DateTime createdAt;

  Product({
    required this.designerName,
    required this.category,
    required this.articleType,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      designerName: json['designerName'],
      category: json['category'],
      articleType: json['articleType'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrls: List<String>.from(json['imageUrls']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'designerName': designerName,
      'category': category,
      'articleType': articleType,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
