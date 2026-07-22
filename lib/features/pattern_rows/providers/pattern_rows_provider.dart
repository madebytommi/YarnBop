import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../library/providers/library_provider.dart';
import '../data/models/pattern_row.dart';

/// Family Provider for PatternRowsNotifier parameterized by projectId.
final patternRowsNotifierProvider = StateNotifierProvider.family
    .autoDispose<PatternRowsNotifier, List<PatternRow>, String>(
        (ref, projectId) {
  final storage = ref.watch(localStorageProvider);
  return PatternRowsNotifier(storage, projectId);
});

/// Riverpod StateNotifier managing a list of [PatternRow] models.
class PatternRowsNotifier extends StateNotifier<List<PatternRow>> {
  final LocalStorageService _storage;
  final String _projectId;

  PatternRowsNotifier(this._storage, this._projectId) : super([]) {
    loadRows();
  }

  /// Loads pattern rows from Hive local storage.
  void loadRows() {
    state = _storage.getPatternRows(_projectId);
  }

  /// Saves the current list of [PatternRow] models to Hive.
  Future<void> saveRows() async {
    await _storage.savePatternRows(_projectId, state);
  }

  /// Toggles the [isCompleted] status of the specified row by [rowNumber]
  /// and automatically persists the updated list to Hive.
  Future<void> toggleRowCompletion(int rowNumber) async {
    state = [
      for (final row in state)
        if (row.rowNumber == rowNumber)
          row.copyWith(isCompleted: !row.isCompleted)
        else
          row,
    ];
    await saveRows();
  }

  /// Adds a new [PatternRow] to the list and saves to Hive.
  Future<void> addRow(PatternRow row) async {
    state = [...state, row];
    await saveRows();
  }

  /// Replaces the list of pattern rows and saves to Hive.
  Future<void> setRows(List<PatternRow> rows) async {
    state = List.from(rows);
    await saveRows();
  }
}
