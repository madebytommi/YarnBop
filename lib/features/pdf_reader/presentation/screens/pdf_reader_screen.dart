import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/project_model.dart';
import '../../../counters/presentation/widgets/overlay_counter_widget.dart';
import '../../../counters/providers/counter_provider.dart';
import '../../../highlighter/presentation/widgets/line_highlighter_widget.dart';
import '../../../highlighter/providers/highlighter_provider.dart';
import '../../../library/providers/library_provider.dart';
import '../widgets/pdf_viewer_canvas.dart';

class PdfReaderScreen extends ConsumerStatefulWidget {
  final String projectId;

  const PdfReaderScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends ConsumerState<PdfReaderScreen> {
  ProjectModel? _project;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projects = ref.read(libraryNotifierProvider);
      final p = projects.firstWhere(
        (element) => element.id == widget.projectId,
        orElse: () => ProjectModel(
          id: widget.projectId,
          title: 'Pattern Project',
          pdfPath: '',
          createdAt: DateTime.now(),
          lastAccessedAt: DateTime.now(),
        ),
      );
      setState(() {
        _project = p;
      });

      // Initialize counter & highlighter state
      ref.read(counterNotifierProvider(widget.projectId).notifier).init(
            initialRow: p.currentRow,
            initialStitch: p.currentStitch,
          );
      ref.read(highlighterYProvider(widget.projectId).notifier).setY(p.highlighterY);
    });
  }

  void _autoSave(int row, int stitch, double highlighterY) {
    if (_project == null) return;
    final updated = _project!.copyWith(
      currentRow: row,
      currentStitch: stitch,
      highlighterY: highlighterY,
      lastAccessedAt: DateTime.now(),
    );
    ref.read(libraryNotifierProvider.notifier).updateProject(updated);
  }

  @override
  Widget build(BuildContext context) {
    final counterState = ref.watch(counterNotifierProvider(widget.projectId));
    final highlighterY = ref.watch(highlighterYProvider(widget.projectId));

    return Scaffold(
      appBar: AppBar(
        title: Text(_project?.title ?? 'Pattern Viewer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _autoSave(counterState.rowCount, counterState.stitchCount, highlighterY);
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // 1. PDF Document Canvas
          PdfViewerCanvas(
            pdfPath: _project?.pdfPath ?? '',
            currentPage: _project?.currentPage ?? 1,
          ),

          // 2. Movable Line Highlighter Overlay
          LineHighlighterWidget(
            yPosition: highlighterY,
            onDragUpdate: (newY) {
              ref.read(highlighterYProvider(widget.projectId).notifier).setY(newY);
              _autoSave(counterState.rowCount, counterState.stitchCount, newY);
            },
          ),

          // 3. Persistent Floating Overlay Counters (Row & Stitch)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row Counter Badge Widget
                OverlayCounterWidget(
                  label: 'ROW',
                  value: counterState.rowCount,
                  onIncrement: () {
                    ref.read(counterNotifierProvider(widget.projectId).notifier).incrementRow();
                    _autoSave(counterState.rowCount + 1, counterState.stitchCount, highlighterY);
                  },
                  onDecrement: () {
                    ref.read(counterNotifierProvider(widget.projectId).notifier).decrementRow();
                    _autoSave(counterState.rowCount > 0 ? counterState.rowCount - 1 : 0, counterState.stitchCount, highlighterY);
                  },
                ),
                // Stitch Counter Badge Widget
                OverlayCounterWidget(
                  label: 'STITCH',
                  value: counterState.stitchCount,
                  onIncrement: () {
                    ref.read(counterNotifierProvider(widget.projectId).notifier).incrementStitch();
                    _autoSave(counterState.rowCount, counterState.stitchCount + 1, highlighterY);
                  },
                  onDecrement: () {
                    ref.read(counterNotifierProvider(widget.projectId).notifier).decrementStitch();
                    _autoSave(counterState.rowCount, counterState.stitchCount > 0 ? counterState.stitchCount - 1 : 0, highlighterY);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
