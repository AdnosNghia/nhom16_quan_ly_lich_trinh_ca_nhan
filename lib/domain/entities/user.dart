class User {
  final String email;
  final String name;
  final String? phoneNumber;
  final bool twoFactorEnabled;

  const User({
    required this.email,
    required this.name,
    this.phoneNumber,
    this.twoFactorEnabled = false,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber ?? '',
      'twoFactorEnabled': twoFactorEnabled,
    };
  }

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String?,
      twoFactorEnabled: data['twoFactorEnabled'] as bool? ?? false,
    );
  }

  User copyWith({String? name, String? phoneNumber, bool? twoFactorEnabled}) {
    return User(
      email: email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
    );
  }
}
