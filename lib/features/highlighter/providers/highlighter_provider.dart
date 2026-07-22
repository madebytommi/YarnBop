import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../library/providers/library_provider.dart';

final highlighterYProvider =
    StateNotifierProvider.autoDispose.family<HighlighterNotifier, double, String>(
        (ref, projectId) {
  final storage = ref.watch(localStorageProvider);
  return HighlighterNotifier(storage, projectId);
});

class HighlighterNotifier extends StateNotifier<double> {
  final LocalStorageService _storage;
  final String _projectId;

  HighlighterNotifier(this._storage, this._projectId) : super(0.0) {
    _initFromHive();
  }

  void _initFromHive() {
    final saved = _storage.getProject(_projectId);
    if (saved != null) {
      state = saved.highlighterY;
    }
  }

  void initY(double initialY) {
    state = initialY >= 0 ? initialY : 0.0;
    _storage.autoSaveHighlighterY(
      projectId: _projectId,
      highlighterY: state,
    );
  }

  void setY(double newY) {
    final nextY = newY < 0 ? 0.0 : newY;
    state = nextY;
    _storage.autoSaveHighlighterY(
      projectId: _projectId,
      highlighterY: nextY,
    );
  }

  void updateDelta(double deltaY) {
    final nextY = (state + deltaY) >= 0 ? (state + deltaY) : 0.0;
    state = nextY;
    _storage.autoSaveHighlighterY(
      projectId: _projectId,
      highlighterY: nextY,
    );
  }
}
