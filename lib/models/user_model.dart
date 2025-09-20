class UserModel {
  final String uid;
  final String email;
  final String role; // 'admin' or 'employee'
  final String? name;

  UserModel({required this.uid, required this.email, required this.role, this.name});

  factory UserModel.fromMap(Map<String, dynamic> map, String id) => UserModel(
        uid: id,
        email: map['email'] ?? '',
        role: map['role'] ?? 'employee',
        name: map['name'],
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'role': role,
        'name': name,
      };
}