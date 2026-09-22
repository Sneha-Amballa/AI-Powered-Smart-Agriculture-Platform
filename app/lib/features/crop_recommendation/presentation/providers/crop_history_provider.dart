import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/crop_history_model.dart';
import '../../data/crop_history_repository.dart';
import 'crop_history_state.dart';

final cropHistoryNotifierProvider =
    NotifierProvider<CropHistoryNotifier, CropHistoryState>(CropHistoryNotifier.new);

class CropHistoryNotifier extends Notifier<CropHistoryState> {
  late CropHistoryRepository _repository;

  @override
  CropHistoryState build() {
    _repository = ref.watch(cropHistoryRepositoryProvider);
    // When auth state changes, load the corresponding farmer's history
    final authState = ref.watch(authNotifierProvider);
    final userId = authState.user?.id ?? '';
    if (userId.isNotEmpty) {
      Future.microtask(() => loadHistory(userId));
    }
    return const CropHistoryState(isLoading: true);
  }

  Future<void> loadHistory([String? explicitUserId]) async {
    final authState = ref.read(authNotifierProvider);
    final userId = explicitUserId ?? authState.user?.id ?? '';
    if (userId.isEmpty) {
      state = state.copyWith(isLoading: false, items: []);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final items = await _repository.getHistory(userId);
      state = state.copyWith(isLoading: false, items: items);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load crop history: ${e.toString()}',
      );
    }
  }

  Future<void> saveNewItem(CropHistoryItem item) async {
    await _repository.saveHistoryItem(item);
    await loadHistory(item.userId);
  }

  Future<void> deleteItem(String id) async {
    final authState = ref.read(authNotifierProvider);
    final userId = authState.user?.id ?? '';
    if (userId.isEmpty) return;

    try {
      await _repository.deleteHistoryItem(userId, id);
      await loadHistory(userId);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete record: ${e.toString()}');
    }
  }

  void selectItem(CropHistoryItem? item) {
    state = state.copyWith(selectedItem: item, clearSelected: item == null);
  }

  Future<void> clearAll() async {
    final authState = ref.read(authNotifierProvider);
    final userId = authState.user?.id ?? '';
    if (userId.isEmpty) return;

    await _repository.clearHistory(userId);
    state = state.copyWith(items: []);
  }
}
