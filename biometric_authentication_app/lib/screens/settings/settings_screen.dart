import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Profile Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: AppTheme.surfaceContainerHighest,
                  child: Icon(Icons.person, size: 32, color: AppTheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Primary Owner', style: AppTextStyles.titleMd.copyWith(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text('+1 234 567 8900', style: AppTextStyles.bodyMd.copyWith(color: AppTheme.onSurface.withOpacity(0.6))),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: AppTheme.surfaceContainer),
          
          _buildSectionHeader('Device'),
          _buildListTile(
            context,
            icon: Icons.lock_outline,
            title: 'Sentinel Front Door',
            subtitle: 'Online • Wi-Fi',
            onTap: () => context.push(AppConstants.deviceSettingsRoute),
          ),
          
          _buildSectionHeader('Account & Security'),
          _buildListTile(context, icon: Icons.fingerprint, title: 'Biometric Authentication', trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppTheme.primary)),
          _buildListTile(context, icon: Icons.password, title: 'Change PIN Code'),
          _buildListTile(context, icon: Icons.notifications_none, title: 'Notification Preferences'),
          
          _buildSectionHeader('App'),
          _buildListTile(context, icon: Icons.dark_mode_outlined, title: 'Dark Mode', subtitle: 'System Default'),
          _buildListTile(context, icon: Icons.help_outline, title: 'Help & Support'),
          _buildListTile(context, icon: Icons.info_outline, title: 'About Sentinel'),
          
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppTheme.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                context.read<AuthProvider>().logout();
                context.go(AppConstants.loginRoute);
              },
              child: const Text('Log Out', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.labelSm.copyWith(
          color: AppTheme.primary,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppTheme.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppTheme.onSurface, size: 24),
      ),
      title: Text(title, style: AppTextStyles.bodyLg),
      subtitle: subtitle != null ? Text(subtitle, style: AppTextStyles.bodyMd.copyWith(color: AppTheme.onSurface.withOpacity(0.5))) : null,
      trailing: trailing ?? Icon(Icons.chevron_right, color: AppTheme.onSurface.withOpacity(0.3)),
      onTap: onTap,
    );
  }
}
