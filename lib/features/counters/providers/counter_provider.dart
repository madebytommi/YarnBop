import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final counterNotifierProvider = StateNotifierProvider.family<CounterNotifier, CounterState, String>((ref, projectId) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(const CounterState());

  void init({required int initialRow, required int initialStitch}) {
    state = CounterState(rowCount: initialRow, stitchCount: initialStitch);
  }

  void incrementRow() {
    state = state.copyWith(rowCount: state.rowCount + 1);
  }

  void decrementRow() {
    if (state.rowCount > 0) {
      state = state.copyWith(rowCount: state.rowCount - 1);
    }
  }

  void incrementStitch() {
    state = state.copyWith(stitchCount: state.stitchCount + 1);
  }

  void decrementStitch() {
    if (state.stitchCount > 0) {
      state = state.copyWith(stitchCount: state.stitchCount - 1);
    }
  }

  void resetStitches() {
    state = state.copyWith(stitchCount: 0);
  }
}
