class Category {
  final String id;
  final String name;
  final int colorHex;
  final String iconCode;

  const Category({
    this.id = '',
    required this.name,
    required this.colorHex,
    this.iconCode = '',
  });

  Category copyWith({
    String? id,
    String? name,
    int? colorHex,
    String? iconCode,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      iconCode: iconCode ?? this.iconCode,
    );
  }
}
