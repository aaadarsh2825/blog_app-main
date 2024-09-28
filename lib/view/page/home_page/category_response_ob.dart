class CategoryResponseOb {
  final bool success;
  final List<CategoryOb> result;

  CategoryResponseOb({required this.success, required this.result});

  factory CategoryResponseOb.fromJson(Map<String, dynamic> json) {
    // Handle potential null values for result
    return CategoryResponseOb(
      success: json['success'],
      result: (json['result'] as List)
          .map((item) => CategoryOb.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result.map((v) => v.toJson()).toList(),
    };
  }
}

class CategoryOb {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  CategoryOb({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryOb.fromJson(Map<String, dynamic> json) {
    return CategoryOb(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
