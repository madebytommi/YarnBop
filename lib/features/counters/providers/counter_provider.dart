import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../library/providers/library_provider.dart';

class CounterState {
  final int rowCount;
  final int stitchCount;

  const CounterState({
    this.rowCount = 0,
    this.stitchCount = 0,
  });

  CounterState copyWith({
    int? rowCount,
    int? stitchCount,
  }) {
    return CounterState(
      rowCount: rowCount ?? this.rowCount,
      stitchCount: stitchCount ?? this.stitchCount,
    );
  }
}

final counterNotifierProvider =
    StateNotifierProvider.autoDispose.family<CounterNotifier, CounterState, String>(
        (ref, projectId) {
  final storage = ref.watch(localStorageProvider);
  return CounterNotifier(storage, projectId);
});

class CounterNotifier extends StateNotifier<CounterState> {
  final LocalStorageService _storage;
  final String _projectId;

  CounterNotifier(this._storage, this._projectId) : super(const CounterState()) {
    _initFromHive();
  }

  void _initFromHive() {
    final saved = _storage.getProject(_projectId);
    if (saved != null) {
      state = CounterState(
        rowCount: saved.currentRow,
        stitchCount: saved.currentStitch,
      );
    }
  }

  void init({required int initialRow, required int initialStitch}) {
    state = CounterState(rowCount: initialRow, stitchCount: initialStitch);
    _storage.autoSaveCounters(
      projectId: _projectId,
      rowCount: initialRow,
      stitchCount: initialStitch,
    );
  }

  void incrementRow() {
    final nextRow = state.rowCount + 1;
    state = state.copyWith(rowCount: nextRow);
    _storage.autoSaveCounters(
      projectId: _projectId,
      rowCount: nextRow,
      stitchCount: state.stitchCount,
    );
  }

  void decrementRow() {
    if (state.rowCount > 0) {
      final nextRow = state.rowCount - 1;
      state = state.copyWith(rowCount: nextRow);
      _storage.autoSaveCounters(
        projectId: _projectId,
        rowCount: nextRow,
        stitchCount: state.stitchCount,
      );
    }
  }

  void incrementStitch() {
    final nextStitch = state.stitchCount + 1;
    state = state.copyWith(stitchCount: nextStitch);
    _storage.autoSaveCounters(
      projectId: _projectId,
      rowCount: state.rowCount,
      stitchCount: nextStitch,
    );
  }

  void decrementStitch() {
    if (state.stitchCount > 0) {
      final nextStitch = state.stitchCount - 1;
      state = state.copyWith(stitchCount: nextStitch);
      _storage.autoSaveCounters(
        projectId: _projectId,
        rowCount: state.rowCount,
        stitchCount: nextStitch,
      );
    }
  }

  void resetStitches() {
    state = state.copyWith(stitchCount: 0);
    _storage.autoSaveCounters(
      projectId: _projectId,
      rowCount: state.rowCount,
      stitchCount: 0,
    );
  }
}
