//User data models
class UserModel {
  final String id;
  final String email;

  UserModel({required this.id, required this.email});

  Map<String, dynamic> toMap() => {'id': id, 'email': email};
  factory UserModel.fromMap(Map<dynamic, dynamic> map) =>
      UserModel(id: map['id'], email: map['email']);
}