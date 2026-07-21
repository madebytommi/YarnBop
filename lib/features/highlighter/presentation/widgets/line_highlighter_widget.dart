import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Draggable line highlighter overlay widget adhering strictly to DESIGN_SYSTEM.md section 5.
class LineHighlighterWidget extends StatelessWidget {
  final double yPosition;
  final ValueChanged<double> onDragUpdate;
  final double height;

  const LineHighlighterWidget({
    super.key,
    required this.yPosition,
    required this.onDragUpdate,
    this.height = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: 0,
      right: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          onDragUpdate(yPosition + details.delta.dy);
        },
        child: Container(
          height: height,
          decoration: const BoxDecoration(
            color: AppColors.highlighterYellowOpacity, // 50% opacity desaturated yellow
            border: Border(
              top: BorderSide(color: AppColors.highlighterBorder, width: 1.5),
              bottom: BorderSide(color: AppColors.highlighterBorder, width: 1.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: AppColors.highlighterBorder,
                child: const Icon(Icons.drag_handle, color: Colors.white, size: 14),
              ),
              const Text(
                'ACTIVE LINE',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B7B00),
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: AppColors.highlighterBorder,
                child: const Icon(Icons.drag_handle, color: Colors.white, size: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
