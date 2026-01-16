class User {
  final String id;
  final String firstname;
  final String lastname;
  final String phone;
  final String role;
  final String? address;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.role,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? '').toString(),
      firstname: (json['firstname'] ?? '').toString(),
      lastname: (json['lastname'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      address: json['address']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'role': role,
      'address': address,
    };
  }

  User copyWith({
    String? firstname,
    String? lastname,
    String? phone,
    String? role,
    String? address,
  }) {
    return User(
      id: id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      address: address ?? this.address,
    );
  }
}
