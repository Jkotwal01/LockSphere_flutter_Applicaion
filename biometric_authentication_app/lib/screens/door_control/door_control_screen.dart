import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/door_provider.dart';
import '../../../widgets/lock_button.dart';
import '../../../widgets/status_chip.dart';

class DoorControlScreen extends StatelessWidget {
  const DoorControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doorProvider = context.watch<DoorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Door Control'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppConstants.settingsRoute),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              
              // Status indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    doorProvider.isOnline ? Icons.wifi : Icons.wifi_off,
                    color: AppTheme.onSurface.withOpacity(0.5),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Connected via ${doorProvider.connectionType}',
                    style: AppTextStyles.labelSm,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StatusChip(isOnline: doorProvider.isOnline),
              
              const Spacer(),
              
              // Main Lock Interaction
              Center(
                child: doorProvider.isLoading
                    ? const SizedBox(
                        width: 250,
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                            strokeWidth: 4,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 250,
                        height: 250,
                        child: LockButton(
                          isLocked: doorProvider.isLocked,
                          onTap: () => doorProvider.toggleLock(),
                        ),
                      ),
              ),
              
              const SizedBox(height: 48),
              
              // Auxiliary Info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Auto-Lock', style: AppTextStyles.labelSm),
                        const SizedBox(height: 4),
                        Text('Active (30s)', style: AppTextStyles.bodyMd),
                      ],
                    ),
                    Switch(
                      value: true,
                      onChanged: (val) {},
                      activeColor: AppTheme.primary,
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
