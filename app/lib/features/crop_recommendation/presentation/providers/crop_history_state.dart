import '../../data/crop_history_model.dart';

class CropHistoryState {
  final bool isLoading;
  final List<CropHistoryItem> items;
  final String? errorMessage;
  final CropHistoryItem? selectedItem;

  const CropHistoryState({
    this.isLoading = false,
    this.items = const [],
    this.errorMessage,
    this.selectedItem,
  });

  bool get isEmpty => !isLoading && items.isEmpty;

  CropHistoryItem? get latestItem => items.isNotEmpty ? items.first : null;

  CropHistoryState copyWith({
    bool? isLoading,
    List<CropHistoryItem>? items,
    String? errorMessage,
    CropHistoryItem? selectedItem,
    bool clearError = false,
    bool clearSelected = false,
  }) {
    return CropHistoryState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedItem: clearSelected ? null : (selectedItem ?? this.selectedItem),
    );
  }
}
