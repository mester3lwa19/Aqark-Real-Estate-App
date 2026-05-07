class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String address;
  final String imageUrl;
  final String ownerId;
  final int timestamp;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.address,
    required this.imageUrl,
    required this.ownerId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'address': address,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'timestamp': timestamp,
    };
  }

  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      address: map['address'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      ownerId: map['ownerId'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }
}
