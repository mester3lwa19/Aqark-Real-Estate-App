import '../../properties/models/models.dart';

class Favorite {
  final String id;
  final String propertyId;
  final String userId;
  final DateTime timestamp;
  final Property propertyDetails;

  Favorite({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.timestamp,
    required this.propertyDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'propertyData': propertyDetails.toMap(),
    };
  }

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] ?? '${json['userId']}_${json['propertyId']}',
      propertyId: json['propertyId'],
      userId: json['userId'],
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
      propertyDetails: Property.fromMap(json['propertyData'] ?? {}),
    );
  }
}
