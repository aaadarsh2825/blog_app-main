class ProfileResponseOb {
  final bool success; // Marked as final for immutability
  final ProfileOb? result; // Nullable to indicate it can be null

  ProfileResponseOb({required this.success, this.result});

  factory ProfileResponseOb.fromJson(Map<String, dynamic> json) {
    return ProfileResponseOb(
      success: json['success'] ?? false, // Defaulting to false if null
      result: json['result'] != null ? ProfileOb.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result?.toJson(), // Using null-aware operator
    };
  }
}

class ProfileOb {
  final int id; // Marked as final for immutability
  final String name;
  final String? image; // Nullable for optional fields
  final String email;
  final String createdAt;
  final String updatedAt;

  ProfileOb({
    required this.id,
    required this.name,
    this.image,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileOb.fromJson(Map<String, dynamic> json) {
    return ProfileOb(
      id: json['id'] ?? 0, // Defaulting to 0 if null
      name: json['name'] ?? '', // Defaulting to empty string if null
      image: json['image'],
      email: json['email'] ?? '', // Defaulting to empty string if null
      createdAt: json['created_at'] ?? '', // Defaulting to empty string if null
      updatedAt: json['updated_at'] ?? '', // Defaulting to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'email': email,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
