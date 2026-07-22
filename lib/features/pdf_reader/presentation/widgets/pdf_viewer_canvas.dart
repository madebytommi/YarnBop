import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/pdf_reader_provider.dart';

/// PDF Viewer Canvas container conforming strictly to DESIGN_SYSTEM.md section 5.
/// The PDF canvas sits flush within the app body, surrounded by the gray background canvas
/// (#F5F8FA) to define its edges, wrapped inside a pure white container with a 1px border (#E6E6E6).
class PdfViewerCanvas extends ConsumerWidget {
  final String projectId;
  final String pdfPath;
  final int initialPage;

  const PdfViewerCanvas({
    super.key,
    required this.projectId,
    required this.pdfPath,
    required this.initialPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pdfState = ref.watch(pdfReaderNotifierProvider(projectId));
    final fileExists = pdfPath.isNotEmpty && File(pdfPath).existsSync();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.backgroundCanvas, // #F5F8FA canvas
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0, top: 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground, // Pure White #FFFFFF
          border: Border.all(color: AppColors.borderGray, width: 1.0), // #E6E6E6 border
          borderRadius: BorderRadius.circular(4.0), // Sharp 2010s border radius
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3.0),
          child: !fileExists
              ? _buildFileMissingPlaceholder(context)
              : pdfState.errorMessage != null
                  ? _buildErrorDisplay(pdfState.errorMessage!)
                  : Stack(
                      children: [
                        PDFView(
                          filePath: pdfPath,
                          enableSwipe: true,
                          swipeHorizontal: false,
                          autoSpacing: false,
                          pageFling: true,
                          pageSnap: true,
                          defaultPage: initialPage > 0 ? initialPage - 1 : 0,
                          fitPolicy: FitPolicy.WIDTH,
                          onRender: (pages) {
                            ref
                                .read(pdfReaderNotifierProvider(projectId).notifier)
                                .onDocumentRendered(pages ?? 1);
                          },
                          onError: (error) {
                            ref
                                .read(pdfReaderNotifierProvider(projectId).notifier)
                                .setPdfError(error.toString());
                          },
                          onPageError: (page, error) {
                            ref
                                .read(pdfReaderNotifierProvider(projectId).notifier)
                                .setPdfError('Error on page $page: $error');
                          },
                          onPageChanged: (page, total) {
                            if (page != null) {
                              ref
                                  .read(pdfReaderNotifierProvider(projectId).notifier)
                                  .onPageChanged(page);
                            }
                          },
                        ),
                        if (pdfState.isLoading)
                          const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildFileMissingPlaceholder(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.picture_as_pdf_outlined,
                size: 48,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'PDF File Not Found on Device',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkCharcoal,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              pdfPath.isEmpty
                  ? 'No PDF file path was assigned to this project.'
                  : 'File path: "$pdfPath"\nPlease verify the file exists on your Android storage.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13.0,
                color: AppColors.textMutedGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorDisplay(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 48,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12.0),
            const Text(
              'Failed to Render PDF',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkCharcoal,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.0,
                color: AppColors.textMutedGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
