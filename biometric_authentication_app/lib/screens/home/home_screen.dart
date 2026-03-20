import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/door_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/notifications_provider.dart';
import '../../../widgets/status_chip.dart';
import '../../../widgets/lock_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doorProvider = context.watch<DoorProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,', style: AppTextStyles.bodyLg),
                      Text('Owner', style: AppTextStyles.headlineSm),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none_rounded, color: AppTheme.onSurface, size: 28),
                            onPressed: () => context.push(AppConstants.notificationsRoute),
                          ),
                          if (context.watch<NotificationsProvider>().unreadCount > 0)
                            Positioned(
                              right: 12,
                              top: 12,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppTheme.error,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          context.read<AuthProvider>().logout();
                          context.go(AppConstants.loginRoute);
                        },
                        child: const CircleAvatar(
                          backgroundColor: AppTheme.surfaceContainerHighest,
                          child: Icon(Icons.person, color: AppTheme.onSurface),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 40),
              
              // Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(
                      doorProvider.isLocked ? 'DOOR IS LOCKED' : 'DOOR IS UNLOCKED',
                      style: AppTextStyles.labelSm.copyWith(
                        color: doorProvider.isLocked ? AppTheme.onSurface : AppTheme.success,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    StatusChip(isOnline: doorProvider.isOnline),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Main CTA
              Center(
                child: doorProvider.isLoading
                    ? const SizedBox(
                        width: 220,
                        height: 220,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    : LockButton(
                        isLocked: doorProvider.isLocked,
                        onTap: () => doorProvider.toggleLock(),
                      ),
              ),

              const SizedBox(height: 48),
              
              // Activity preview
              Center(
                child: Text(
                  doorProvider.isLocked ? 'Locked by You • Just now' : 'Unlocked by You • Just now',
                  style: AppTextStyles.bodyMd.copyWith(color: AppTheme.onSurface.withOpacity(0.5)),
                ),
              ),
              
              const Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          border: Border(top: BorderSide(color: AppTheme.surfaceContainer, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(icon: Icons.home_filled, label: 'Home', isActive: true, onTap: () {}),
            _NavItem(
              icon: Icons.people_alt_outlined, 
              label: 'Access', 
              isActive: false, 
              onTap: () => context.push(AppConstants.accessRoute),
            ),
            _NavItem(
              icon: Icons.history_rounded, 
              label: 'Logs', 
              isActive: false, 
              onTap: () => context.push(AppConstants.logsRoute),
            ),
            _NavItem(
              icon: Icons.settings_outlined, 
              label: 'Settings', 
              isActive: false, 
              onTap: () => context.push(AppConstants.settingsRoute),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppConstants.deviceSetupRoute),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: AppTheme.surface),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isActive ? AppTheme.primary : AppTheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: isActive ? AppTheme.primary : AppTheme.onSurface.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }
}
