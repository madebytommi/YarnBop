import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Rigid, semi-transparent overlay widget counter adhering to DESIGN_SYSTEM.md section 5.
class OverlayCounterWidget extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const OverlayCounterWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.counterWidgetBg, // rgba(20, 23, 26, 0.85)
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.white24, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(
              color: AppColors.counterText,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          // Decrement Square Button
          InkWell(
            onTap: onDecrement,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(2.0),
                border: Border.all(color: Colors.white30, width: 1.0),
              ),
              child: const Icon(Icons.remove, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 4.0),
          // Increment Square Button
          InkWell(
            onTap: onIncrement,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(2.0),
                border: Border.all(color: Colors.white30, width: 1.0),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
