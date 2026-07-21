import 'package:flutter_riverpod/flutter_riverpod.dart';

final highlighterYProvider = StateNotifierProvider.family<HighlighterNotifier, double, String>((ref, projectId) {
  return HighlighterNotifier();
});

class HighlighterNotifier extends StateNotifier<double> {
  HighlighterNotifier() : super(120.0);

  void setY(double y) {
    state = y;
  }

  void moveDown(double delta) {
    state = state + delta;
  }

  void moveUp(double delta) {
    if (state - delta >= 0) {
      state = state - delta;
    }
  }
}
