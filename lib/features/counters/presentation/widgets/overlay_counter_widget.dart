import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Floating Overlay Counter Widget for Row and Stitch counting.
/// Conforms strictly to DESIGN_SYSTEM.md section 5:
/// Dark semi-transparent background (rgba(20, 23, 26, 0.85)), crisp white text,
/// and rigid square + and - buttons inside the widget.
class OverlayCounterWidget extends StatelessWidget {
  final int rowCount;
  final int stitchCount;
  final VoidCallback onIncrementRow;
  final VoidCallback onDecrementRow;
  final VoidCallback onIncrementStitch;
  final VoidCallback onDecrementStitch;
  final VoidCallback? onResetStitch;

  const OverlayCounterWidget({
    super.key,
    required this.rowCount,
    required this.stitchCount,
    required this.onIncrementRow,
    required this.onDecrementRow,
    required this.onIncrementStitch,
    required this.onDecrementStitch,
    this.onResetStitch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.counterWidgetBg, // rgba(20, 23, 26, 0.85)
        borderRadius: BorderRadius.circular(4.0), // 2010s rigid badge border radius
        border: Border.all(color: Colors.white24, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- ROW COUNTER ---
          _buildCounterGroup(
            label: 'ROW',
            count: rowCount,
            onIncrement: onIncrementRow,
            onDecrement: onDecrementRow,
          ),

          const SizedBox(width: 16.0),

          // Divider
          Container(
            height: 24.0,
            width: 1.0,
            color: Colors.white24,
          ),

          const SizedBox(width: 16.0),

          // --- STITCH COUNTER ---
          _buildCounterGroup(
            label: 'STITCH',
            count: stitchCount,
            onIncrement: onIncrementStitch,
            onDecrement: onDecrementStitch,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterGroup({
    required String label,
    required int count,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label & Count Value
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              '$count',
              style: const TextStyle(
                color: AppColors.counterText, // Crisp White
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(width: 10.0),

        // Square Decrement (-) Button
        InkWell(
          onTap: onDecrement,
          borderRadius: BorderRadius.circular(2.0),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(2.0),
              border: Border.all(color: Colors.white30, width: 1.0),
            ),
            child: const Icon(
              Icons.remove,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),

        const SizedBox(width: 4.0),

        // Square Increment (+) Button
        InkWell(
          onTap: onIncrement,
          borderRadius: BorderRadius.circular(2.0),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue, // Classic Web Blue accent
              borderRadius: BorderRadius.circular(2.0),
              border: Border.all(color: Colors.white30, width: 1.0),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}
