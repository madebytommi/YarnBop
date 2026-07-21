import 'package:flutter_riverpod/flutter_riverpod.dart';

class PdfReaderState {
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final String? errorMessage;

  const PdfReaderState({
    this.currentPage = 1,
    this.totalPages = 1,
    this.isLoading = false,
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
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final pdfReaderNotifierProvider = StateNotifierProvider.family<PdfReaderNotifier, PdfReaderState, String>((ref, projectId) {
  return PdfReaderNotifier();
});

class PdfReaderNotifier extends StateNotifier<PdfReaderState> {
  PdfReaderNotifier() : super(const PdfReaderState());

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setTotalPages(int total) {
    state = state.copyWith(totalPages: total);
  }
}
