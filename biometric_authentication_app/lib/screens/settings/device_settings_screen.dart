import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_styles.dart';

class DeviceSettingsScreen extends StatelessWidget {
  const DeviceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Device Hero
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primary.withOpacity(0.3), width: 4),
                  ),
                  child: const Icon(Icons.lock_outline, size: 50, color: AppTheme.primary),
                ),
                const SizedBox(height: 16),
                Text('Sentinel Front Door', style: AppTextStyles.headlineSm),
                const SizedBox(height: 4),
                Text('Connected via Home Wi-Fi', style: AppTextStyles.bodyMd.copyWith(color: AppTheme.success)),
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          
          Text('Hardware Info', style: AppTextStyles.titleMd),
          const SizedBox(height: 16),
          _buildInfoRow('Model', 'Sentinel Pro Gen 2'),
          _buildInfoRow('Firmware Version', 'v2.0.4 (Up to date)'),
          _buildInfoRow('Serial Number', 'SNTL-8A29-B41C'),
          _buildInfoRow('Battery Level', '84% (Good)'),
          
          const SizedBox(height: 32),
          Text('Network', style: AppTextStyles.titleMd),
          const SizedBox(height: 16),
          _buildInfoRow('Wi-Fi SSID', 'Home_Net_5G'),
          _buildInfoRow('IP Address', '192.168.1.104'),
          _buildInfoRow('MAC Address', 'A4:C1:38:5E:9B:12'),
          
          const SizedBox(height: 56),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: AppTheme.surface,
              ),
              onPressed: () => _showUnpairDialog(context),
              child: const Text('Remove Device'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppTheme.onSurface.withOpacity(0.7))),
          Text(value, style: AppTextStyles.bodyLg),
        ],
      ),
    );
  }

  void _showUnpairDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHighest,
        title: Text('Remove Device?', style: AppTextStyles.titleMd),
        content: Text('Are you sure you want to unpair this Sentinel lock? You will need to physically reset the device to pair it again.', style: AppTextStyles.bodyMd),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Device removed')));
              context.pop();
            }, 
            child: const Text('Remove', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
