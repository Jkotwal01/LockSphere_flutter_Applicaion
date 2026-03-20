import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/text_styles.dart';

class LockButton extends StatelessWidget {
  final bool isLocked;
  final VoidCallback onTap;

  const LockButton({
    super.key, 
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isLocked
                ? [AppTheme.primary, AppTheme.primaryContainer]
                : [AppTheme.success.withOpacity(0.7), AppTheme.success.withOpacity(0.4)],
          ),
          boxShadow: [
            BoxShadow(
              color: (isLocked ? AppTheme.primary : AppTheme.success).withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 10,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isLocked ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                size: 64,
                color: AppTheme.surface,
              ),
              const SizedBox(height: 12),
              Text(
                isLocked ? 'TAP TO UNLOCK' : 'TAP TO LOCK',
                style: AppTextStyles.titleSm.copyWith(
                  color: AppTheme.surface,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
