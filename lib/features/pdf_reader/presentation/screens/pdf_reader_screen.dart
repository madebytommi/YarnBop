import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/project_model.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../../counters/presentation/widgets/overlay_counter_widget.dart';
import '../../../counters/providers/counter_provider.dart';
import '../../../highlighter/presentation/widgets/line_highlighter_widget.dart';
import '../../../highlighter/providers/highlighter_provider.dart';
import '../../../library/providers/library_provider.dart';
import '../../providers/pdf_reader_provider.dart';
import '../widgets/pdf_viewer_canvas.dart';

/// PdfReaderScreen combining PDF document rendering, movable line highlighter overlay,
/// and floating rigid counter badges.
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
      final project = projects.firstWhere(
        (element) => element.id == widget.projectId,
        orElse: () => ProjectModel.empty(widget.projectId),
      );

      setState(() {
        _project = project;
      });

      // Initialize page state
      ref
          .read(pdfReaderNotifierProvider(widget.projectId).notifier)
          .initPage(project.currentPage);

      // Initialize counter state
      ref.read(counterNotifierProvider(widget.projectId).notifier).init(
            initialRow: project.currentRow,
            initialStitch: project.currentStitch,
          );

      // Initialize line highlighter Y position
      ref
          .read(highlighterYProvider(widget.projectId).notifier)
          .initY(project.highlighterY);
    });
  }

  void _saveProgress() {
    if (_project == null) return;
    final pdfState = ref.read(pdfReaderNotifierProvider(widget.projectId));
    final counterState = ref.read(counterNotifierProvider(widget.projectId));
    final highlighterY = ref.read(highlighterYProvider(widget.projectId));

    final updated = _project!.copyWith(
      currentPage: pdfState.currentPage,
      currentRow: counterState.rowCount,
      currentStitch: counterState.stitchCount,
      highlighterY: highlighterY,
      lastAccessedAt: DateTime.now(),
    );
    ref.read(libraryNotifierProvider.notifier).updateProject(updated);
  }

  @override
  Widget build(BuildContext context) {
    final pdfState = ref.watch(pdfReaderNotifierProvider(widget.projectId));
    final counterState = ref.watch(counterNotifierProvider(widget.projectId));
    final highlighterY = ref.watch(highlighterYProvider(widget.projectId));

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _saveProgress();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundCanvas, // #F5F8FA
        appBar: AppBar(
          backgroundColor: AppColors.primaryBlue, // Classic Web Blue #1DA1F2
          elevation: 2.0, // Sharp 2010s drop shadow line
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _saveProgress();
              Navigator.pop(context);
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _project?.title ?? 'Pattern Viewer',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!pdfState.isLoading && pdfState.errorMessage == null)
                Text(
                  'Page ${pdfState.currentPage} of ${pdfState.totalPages}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(color: Colors.white24, width: 1.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.picture_as_pdf, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '${pdfState.currentPage}/${pdfState.totalPages}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            // LAYER 1 (Bottom): PDF Viewer Canvas
            PdfViewerCanvas(
              projectId: widget.projectId,
              pdfPath: LocalStorageService.getAbsolutePdfPath(_project?.pdfPath ?? ''),
              initialPage: _project?.currentPage ?? 1,
            ),

            // LAYER 2 (Middle): Movable Line Highlighter Overlay
            LineHighlighterWidget(
              yPosition: highlighterY,
              onDragUpdate: (deltaY) {
                ref
                    .read(highlighterYProvider(widget.projectId).notifier)
                    .updateDelta(deltaY);
                _saveProgress();
              },
            ),

            // LAYER 3 (Top): Floating Overlay Counter Badge (never obstructed by yellow highlighter band)
            Positioned(
              bottom: 24.0,
              right: 20.0,
              child: OverlayCounterWidget(
                rowCount: counterState.rowCount,
                stitchCount: counterState.stitchCount,
                onIncrementRow: () {
                  ref
                      .read(counterNotifierProvider(widget.projectId).notifier)
                      .incrementRow();
                  _saveProgress();
                },
                onDecrementRow: () {
                  ref
                      .read(counterNotifierProvider(widget.projectId).notifier)
                      .decrementRow();
                  _saveProgress();
                },
                onIncrementStitch: () {
                  ref
                      .read(counterNotifierProvider(widget.projectId).notifier)
                      .incrementStitch();
                  _saveProgress();
                },
                onDecrementStitch: () {
                  ref
                      .read(counterNotifierProvider(widget.projectId).notifier)
                      .decrementStitch();
                  _saveProgress();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
