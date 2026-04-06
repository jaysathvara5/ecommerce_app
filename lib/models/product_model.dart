class Product {
  final String id, name, image, desc, category;
  final double price, rating;
  final int ratingCount;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.desc,
    required this.category,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final ratingData = json['rating'];
    double ratingValue = 0.0;
    int ratingCountValue = 0;

    if (ratingData is Map) {
      ratingValue = double.tryParse(ratingData['rate'].toString()) ?? 0.0;
      ratingCountValue = int.tryParse(ratingData['count'].toString()) ?? 0;
    } else if (ratingData is num) {
      ratingValue = ratingData.toDouble();
      ratingCountValue = int.tryParse(json['stock']?.toString() ?? '0') ?? 0;
    }

    return Product(
      id: json['id'].toString(),
      name: json['title'],
      price: double.parse(json['price'].toString()),
      image: json['thumbnail'] ?? json['image'] ?? '',
      desc: json['description'],
      category: json['category'],
      rating: ratingValue,
      ratingCount: ratingCountValue,
    );
  }
}
