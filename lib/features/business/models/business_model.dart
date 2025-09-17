enum BusinessType {
  restaurant('Restaurant'),
  wholesaleRetail('Wholesale & Retail');

  const BusinessType(this.displayName);
  final String displayName;
}

class BusinessModel {
  final String id;
  final String name;
  final BusinessType businessType;
  final String? description;
  final String? address;
  final String? phone;
  final String? email;
  final String? website;
  final String? taxNumber;
  final String? registrationNumber;
  final String ownerId; // User ID who owns this business
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const BusinessModel({
    required this.id,
    required this.name,
    required this.businessType,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.address,
    this.phone,
    this.email,
    this.website,
    this.taxNumber,
    this.registrationNumber,
    this.isActive = true,
  });

  BusinessModel copyWith({
    String? id,
    String? name,
    BusinessType? businessType,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? taxNumber,
    String? registrationNumber,
    String? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      businessType: businessType ?? this.businessType,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      taxNumber: taxNumber ?? this.taxNumber,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'business_type': businessType.name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'tax_number': taxNumber,
      'registration_number': registrationNumber,
      'owner_id': ownerId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] as String,
      name: json['name'] as String,
      businessType: BusinessType.values.firstWhere(
        (type) => type.name == json['business_type'],
        orElse: () => BusinessType.restaurant,
      ),
      description: json['description'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      taxNumber: json['tax_number'] as String?,
      registrationNumber: json['registration_number'] as String?,
      ownerId: json['owner_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BusinessModel &&
        other.id == id &&
        other.name == name &&
        other.businessType == businessType &&
        other.description == description &&
        other.address == address &&
        other.phone == phone &&
        other.email == email &&
        other.website == website &&
        other.taxNumber == taxNumber &&
        other.registrationNumber == registrationNumber &&
        other.ownerId == ownerId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      businessType,
      description,
      address,
      phone,
      email,
      website,
      taxNumber,
      registrationNumber,
      ownerId,
      createdAt,
      updatedAt,
      isActive,
    );
  }

  @override
  String toString() {
    return 'BusinessModel(id: $id, name: $name, businessType: $businessType, ownerId: $ownerId, isActive: $isActive)';
  }
}