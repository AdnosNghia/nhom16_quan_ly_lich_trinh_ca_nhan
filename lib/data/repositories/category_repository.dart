import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/category.dart';

class CategoryRepository {
  final CollectionReference _categories = FirebaseFirestore.instance.collection('categories');

  Stream<List<Category>> watchAllCategories() {
    return _categories.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Category(
          id: doc.id,
          name: data['name'] as String,
          colorHex: data['colorHex'] as int,
          iconCode: data['iconCode'] as String,
        );
      }).toList();
    });
  }

  Future<List<Category>> getAllCategories() async {
    final snapshot = await _categories.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Category(
        id: doc.id,
        name: data['name'] as String,
        colorHex: data['colorHex'] as int,
        iconCode: data['iconCode'] as String,
      );
    }).toList();
  }

  Future<Category?> getCategoryById(String id) async {
    final doc = await _categories.doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] as String,
      colorHex: data['colorHex'] as int,
      iconCode: data['iconCode'] as String,
    );
  }

  Future<void> insertCategory(Category category) async {
    final id = const Uuid().v4();
    await _categories.doc(id).set({
      'name': category.name,
      'colorHex': category.colorHex,
      'iconCode': category.iconCode,
    });
  }

  Future<void> updateCategory(Category category) async {
    await _categories.doc(category.id).update({
      'name': category.name,
      'colorHex': category.colorHex,
      'iconCode': category.iconCode,
    });
  }

  Future<void> deleteCategory(String id) async {
    await _categories.doc(id).delete();
  }
}
