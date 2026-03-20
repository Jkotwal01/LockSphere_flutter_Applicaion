import 'package:flutter/material.dart';
import '../core/theme/text_styles.dart';

class StatusChip extends StatelessWidget {
  final bool isOnline;

  const StatusChip({super.key, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    final color = isOnline 
        ? Theme.of(context).colorScheme.primary 
        : Theme.of(context).colorScheme.secondary;
        
    final label = isOnline ? 'ONLINE' : 'OFFLINE';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
