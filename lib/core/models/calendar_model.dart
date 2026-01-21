class Calendar {
  final String id;
  final String name;
  final String color;
  final bool isDefault;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Calendar({
    required this.id,
    required this.name,
    required this.color,
    required this.isDefault,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      id: json['\$id'] ?? '',
      name: json['name'] ?? '',
      color: json['color'] ?? '#000000',
      isDefault: json['isDefault'] ?? false,
      userId: json['userId'] ?? '',
      createdAt: DateTime.parse(json['\$createdAt']),
      updatedAt: DateTime.parse(json['\$updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color,
      'isDefault': isDefault,
      'userId': userId,
    };
  }
}
