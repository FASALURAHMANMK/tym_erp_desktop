class UserModel {
  final String id;
  final String phone;
  final String fullName;
  final String? email;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.phone,
    required this.fullName,
    this.email,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'fullName': fullName,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? phone,
    String? fullName,
    String? email,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.phone == phone &&
        other.fullName == fullName &&
        other.email == email &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, phone, fullName, email, createdAt);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, phone: $phone, fullName: $fullName, email: $email, createdAt: $createdAt)';
  }
}