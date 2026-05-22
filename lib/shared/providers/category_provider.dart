import 'package:flutter/material.dart';
import '../../data/repositories/category_repository.dart';
import '../../domain/entities/category.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<Category> _categories = [];

  List<Category> get categories => _categories;

  Future<void> loadCategories() async {
    try {
      _categories = await _repository.getAllCategories().timeout(const Duration(seconds: 15));
    } catch (_) {
      _categories = [];
    }
    if (_categories.length < 8) {
      try {
        await _seedMissingCategories().timeout(const Duration(seconds: 10));
        _categories = await _repository.getAllCategories().timeout(const Duration(seconds: 10));
      } catch (_) {}
    }
    notifyListeners();
  }

  Future<void> _seedMissingCategories() async {
    final existingNames = _categories.map((c) => c.name).toSet();
    const defaults = [
      ('Công việc', 0xFF4D41DF, 'work'),
      ('Học tập', 0xFF2196F3, 'study'),
      ('Sức khỏe', 0xFF4CAF50, 'health'),
      ('Cá nhân', 0xFFFF9800, 'personal'),
      ('Gia đình', 0xFFE91E63, 'family'),
      ('Giải trí', 0xFF9C27B0, 'entertainment'),
      ('Thể thao', 0xFF00BCD4, 'sports'),
      ('Ủy thác', 0xFF607D8B, 'delegate'),
    ];
    for (final (name, color, icon) in defaults) {
      if (!existingNames.contains(name)) {
        await _repository.insertCategory(Category(
          id: '',
          name: name,
          colorHex: color,
          iconCode: icon,
        ));
      }
    }
  }

  Color getColorForCategory(String categoryId) {
    final cat = _categories.where((c) => c.id == categoryId).firstOrNull;
    if (cat != null) return Color(cat.colorHex);
    return const Color(0xFF4D41DF);
  }

  String getNameForCategory(String categoryId) {
    final cat = _categories.where((c) => c.id == categoryId).firstOrNull;
    if (cat != null) return cat.name;
    return '';
  }

  Category? getCategoryById(String id) {
    return _categories.where((c) => c.id == id).firstOrNull;
  }

  Category? getCategoryByName(String name) {
    return _categories.where((c) => c.name == name).firstOrNull;
  }
}
