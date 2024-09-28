class BlogResponseOb {
  final bool success;
  final BlogResultOb result;

  BlogResponseOb({required this.success, required this.result});

  factory BlogResponseOb.fromJson(Map<String, dynamic> json) {
    return BlogResponseOb(
      success: json['success'],
      result: json['result'] != null ? BlogResultOb.fromJson(json['result']) : throw Exception('Result is null'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result.toJson(),
    };
  }
}

class BlogResultOb {
  final int currentPage;
  final List<BlogOb> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  BlogResultOb({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory BlogResultOb.fromJson(Map<String, dynamic> json) {
    return BlogResultOb(
      currentPage: json['current_page'],
      data: (json['data'] as List).map((item) => BlogOb.fromJson(item)).toList(),
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((item) => item.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class BlogOb {
  final int id;
  final String categoryId;
  final String userId;
  final String title;
  final String image;
  final String description;
  final String createdAt;
  final String updatedAt;
  final Category? category;
  final User? user;

  BlogOb({
    required this.id,
    required this.categoryId,
    required this.userId,
    required this.title,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.user,
  });

  factory BlogOb.fromJson(Map<String, dynamic> json) {
    return BlogOb(
      id: json['id'],
      categoryId: json['category_id'],
      userId: json['user_id'],
      title: json['title'],
      image: json['image'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'user_id': userId,
      'title': title,
      'image': image,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category?.toJson(),
      'user': user?.toJson(),
    };
  }
}

class Category {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
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

class User {
  final int id;
  final String name;
  final String image;
  final String email;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      email: json['email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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

class Links {
  final String url;
  final String label;
  final bool active;

  Links({required this.url, required this.label, required this.active});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
