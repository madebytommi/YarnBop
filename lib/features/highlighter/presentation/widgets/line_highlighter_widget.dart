import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Draggable Movable Line Highlighter Overlay Widget.
/// Conforms strictly to DESIGN_SYSTEM.md section 5:
/// Horizontal band spanning the full width of the screen with a desaturated warm yellow
/// background (rgba(255, 249, 196, 0.5)) and thin solid border lines (rgba(200, 180, 0, 0.8))
/// on top and bottom edges.
class LineHighlighterWidget extends StatelessWidget {
  final double yPosition;
  final ValueChanged<double> onDragUpdate;
  final double height;

  const LineHighlighterWidget({
    super.key,
    required this.yPosition,
    required this.onDragUpdate,
    this.height = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: 0,
      right: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (details) {
          onDragUpdate(details.delta.dy);
        },
        child: Container(
          height: height,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.highlighterYellowOpacity, // rgba(255, 249, 196, 0.5)
            border: Border(
              top: BorderSide(color: AppColors.highlighterBorder, width: 1.5), // rgba(200, 180, 0, 0.8)
              bottom: BorderSide(color: AppColors.highlighterBorder, width: 1.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Drag Handle Badge
              Container(
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                color: AppColors.highlighterBorder.withValues(alpha: 0.25),
                child: const Icon(
                  Icons.drag_handle,
                  color: Color(0xFF6B5E00),
                  size: 18,
                ),
              ),
              // Center Subtle Indicator Text
              const Text(
                'ACTIVE PATTERN ROW',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B5E00),
                  letterSpacing: 1.2,
                ),
              ),
              // Right Drag Handle Badge
              Container(
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                color: AppColors.highlighterBorder.withValues(alpha: 0.25),
                child: const Icon(
                  Icons.drag_handle,
                  color: Color(0xFF6B5E00),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
