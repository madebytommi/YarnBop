import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// PDF Viewer Canvas container conforming to DESIGN_SYSTEM.md section 5.
class PdfViewerCanvas extends StatelessWidget {
  final String pdfPath;
  final int currentPage;

  const PdfViewerCanvas({
    super.key,
    required this.pdfPath,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.backgroundCanvas,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground, // Pure White
          border: Border.all(color: AppColors.borderGray, width: 1.0),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: AppColors.primaryBlue.withValues(alpha: 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PATTERN DOCUMENT — PAGE $currentPage',
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const Icon(Icons.picture_as_pdf, size: 18, color: AppColors.primaryBlue),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Cast On & Foundation Row:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDarkCharcoal),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Row 1 (RS): K2, p2, *k4, p2; rep from * to last 2 sts, k2.\n'
                  'Row 2 (WS): P2, k2, *p4, k2; rep from * to last 2 sts, p2.\n'
                  'Row 3: K2, p2, *C4F, p2; rep from * to last 2 sts, k2.\n'
                  'Row 4: Repeat Row 2.\n'
                  'Row 5: Repeat Row 1.\n'
                  'Row 6: Repeat Row 2.\n'
                  'Row 7: K2, p2, *k4, p2; rep from * to last 2 sts, k2.\n'
                  'Row 8: Repeat Row 2.',
                  style: TextStyle(height: 1.8, fontSize: 14, color: AppColors.textDarkCharcoal),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  'Shape Raglan Sleeves:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDarkCharcoal),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Row 9 (Dec Row): K1, ssk, pattern to last 3 sts, k2tog, k1.\n'
                  'Row 10: Work in pattern as established.\n'
                  'Repeat Rows 9-10 another 14 times. [32 sts remaining]',
                  style: TextStyle(height: 1.8, fontSize: 14, color: AppColors.textDarkCharcoal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
