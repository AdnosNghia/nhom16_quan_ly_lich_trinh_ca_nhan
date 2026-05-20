class User {
  final String email;
  final String name;
  final String? phoneNumber;

  const User({required this.email, required this.name, this.phoneNumber});

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber ?? '',
    };
  }

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String?,
    );
  }

  User copyWith({String? name, String? phoneNumber}) {
    return User(
      email: email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
