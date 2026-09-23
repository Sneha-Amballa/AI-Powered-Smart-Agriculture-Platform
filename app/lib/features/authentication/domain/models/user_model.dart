/// Represents a registered farmer user account.
class UserModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String preferredLanguage;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.preferredLanguage = 'en',
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? preferredLanguage,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      if (email != null) 'email': email,
      'preferred_language': preferredLanguage,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] as String? ?? json['name'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? json['phone'] as String? ?? '',
      email: json['email'] as String?,
      preferredLanguage: json['preferred_language'] as String? ?? 'en',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          phoneNumber == other.phoneNumber &&
          email == other.email &&
          preferredLanguage == other.preferredLanguage;

  @override
  int get hashCode =>
      id.hashCode ^ phoneNumber.hashCode ^ email.hashCode ^ preferredLanguage.hashCode;

  @override
  String toString() =>
      'UserModel(id: $id, fullName: $fullName, phoneNumber: $phoneNumber, email: $email, preferredLanguage: $preferredLanguage)';
}

