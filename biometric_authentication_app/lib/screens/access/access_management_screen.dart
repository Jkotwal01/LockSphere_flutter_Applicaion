import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../providers/access_provider.dart';

class AccessManagementScreen extends StatefulWidget {
  const AccessManagementScreen({super.key});

  @override
  State<AccessManagementScreen> createState() => _AccessManagementScreenState();
}

class _AccessManagementScreenState extends State<AccessManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Load list when screen opens
    Future.microtask(() {
      context.read<AccessProvider>().loadAccessList('esp32_device_01');
    });
  }

  void _revokeAccess(String id) async {
    final success = await context.read<AccessProvider>().revokeAccess(id);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Access revoked')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final accessProvider = context.watch<AccessProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: accessProvider.isLoading && accessProvider.accessList.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : accessProvider.accessList.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.only(top: 16, bottom: 100),
                  itemCount: accessProvider.accessList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = accessProvider.accessList[index];
                    return _buildUserCard(context, item);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppConstants.addUserRoute),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.person_add_alt_1, color: AppTheme.surface),
        label: const Text('Add User', style: TextStyle(color: AppTheme.surface, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: AppTheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text('No external users found', style: AppTextStyles.headlineSm),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add family\nmembers or temporary guests.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMd.copyWith(color: AppTheme.onSurface.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, dynamic user) {
    return Dismissible(
      key: Key(user.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppTheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: AppTheme.onSurface),
      ),
      onDismissed: (_) => _revokeAccess(user.id),
      confirmDismiss: (_) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppTheme.surfaceContainerHighest,
            title: Text('Revoke Access?', style: AppTextStyles.titleMd),
            content: Text('Are you sure you want to remove ${user.name}?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true), 
                child: const Text('Revoke', style: TextStyle(color: AppTheme.error)),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppTheme.surfaceContainerHighest,
              child: Text(
                user.name[0].toUpperCase(),
                style: AppTextStyles.titleMd.copyWith(color: AppTheme.primary),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user.name, style: AppTextStyles.titleMd),
                      const SizedBox(width: 8),
                      // Role chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: user.role == 'Owner' ? AppTheme.primary.withOpacity(0.2) : AppTheme.tertiary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          user.role,
                          style: AppTextStyles.labelSm.copyWith(
                            color: user.role == 'Owner' ? AppTheme.primary : AppTheme.tertiary,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(user.phoneOrEmail, style: AppTextStyles.bodyMd.copyWith(color: AppTheme.onSurface.withOpacity(0.7))),
                  
                  if (user.isTemporary) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 14, color: AppTheme.tertiary),
                        const SizedBox(width: 4),
                        Text(
                          'Until ${DateFormat('MMM d, h:mm a').format(user.endTime!)}',
                          style: AppTextStyles.labelSm.copyWith(color: AppTheme.tertiary),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
