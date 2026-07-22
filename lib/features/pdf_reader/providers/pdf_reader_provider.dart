import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../library/providers/library_provider.dart';

class PdfReaderState {
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final String? errorMessage;

  const PdfReaderState({
    this.currentPage = 1,
    this.totalPages = 1,
    this.isLoading = true,
    this.errorMessage,
  });

  PdfReaderState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PdfReaderState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

final pdfReaderNotifierProvider =
    StateNotifierProvider.autoDispose.family<PdfReaderNotifier, PdfReaderState, String>(
        (ref, projectId) {
  final storage = ref.watch(localStorageProvider);
  return PdfReaderNotifier(storage, projectId);
});

class PdfReaderNotifier extends StateNotifier<PdfReaderState> {
  final LocalStorageService _storage;
  final String _projectId;

  PdfReaderNotifier(this._storage, this._projectId)
      : super(const PdfReaderState()) {
    _initFromHive();
  }

  void _initFromHive() {
    final saved = _storage.getProject(_projectId);
    if (saved != null) {
      state = state.copyWith(currentPage: saved.currentPage);
    }
  }

  void initPage(int initialPage) {
    state = state.copyWith(
      currentPage: initialPage,
      isLoading: true,
      errorMessage: null,
    );
    _storage.autoSaveCurrentPage(
      projectId: _projectId,
      currentPage: initialPage,
    );
  }

  void onDocumentRendered(int totalPages) {
    state = state.copyWith(
      totalPages: totalPages,
      isLoading: false,
      errorMessage: null,
    );
  }

  void onPageChanged(int page) {
    final newPage = page + 1; // 1-based indexing for display
    state = state.copyWith(currentPage: newPage);
    _storage.autoSaveCurrentPage(
      projectId: _projectId,
      currentPage: newPage,
    );
  }

  void setPdfError(String message) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: message,
    );
  }
}
