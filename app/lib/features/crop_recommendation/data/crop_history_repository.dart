import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'crop_history_model.dart';

/// Riverpod provider for CropHistoryRepository
final cropHistoryRepositoryProvider = Provider<CropHistoryRepository>((ref) {
  return CropHistoryRepositoryImpl();
});

abstract class CropHistoryRepository {
  Future<List<CropHistoryItem>> getHistory(String userId);
  Future<void> saveHistoryItem(CropHistoryItem item);
  Future<CropHistoryItem?> getLatestRecommendation(String userId);
  Future<void> deleteHistoryItem(String userId, String id);
  Future<void> clearHistory(String userId);
}

class CropHistoryRepositoryImpl implements CropHistoryRepository {
  static const String _keyPrefix = 'kisan_crop_history_';

  String _getKey(String userId) => '$_keyPrefix$userId';

  @override
  Future<List<CropHistoryItem>> getHistory(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_getKey(userId));
    if (rawList == null || rawList.isEmpty) return [];

    final items = <CropHistoryItem>[];
    for (final raw in rawList) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        items.add(CropHistoryItem.fromJson(decoded));
      } catch (_) {
        // Skip corrupted items
      }
    }

    // Sort latest first
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<void> saveHistoryItem(CropHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = prefs.getStringList(_getKey(item.userId)) ?? [];

    final itemJson = jsonEncode(item.toJson());
    // Prepend latest recommendation
    final updatedList = [itemJson, ...currentList];

    await prefs.setStringList(_getKey(item.userId), updatedList);
  }

  @override
  Future<CropHistoryItem?> getLatestRecommendation(String userId) async {
    final items = await getHistory(userId);
    if (items.isEmpty) return null;
    return items.first;
  }

  @override
  Future<void> deleteHistoryItem(String userId, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getHistory(userId);
    final filtered = items.where((item) => item.id != id).toList();
    final updatedList = filtered.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_getKey(userId), updatedList);
  }

  @override
  Future<void> clearHistory(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_getKey(userId));
  }
}
