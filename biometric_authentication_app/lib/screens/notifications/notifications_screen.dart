import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../providers/notifications_provider.dart';
import '../../../models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NotificationsProvider>().fetchNotifications('esp32_device_01');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: provider.isLoading && provider.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : provider.notifications.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: provider.notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 1), // Divider handled inside
                  itemBuilder: (context, index) {
                    return _buildNotificationTile(context, provider.notifications[index], provider);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: AppTheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text('You\'re all caught up', style: AppTextStyles.headlineSm),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(BuildContext context, NotificationModel notif, NotificationsProvider provider) {
    IconData icon;
    Color iconColor;

    if (notif.isAlert) {
      icon = Icons.warning_amber_rounded;
      iconColor = AppTheme.error;
    } else if (notif.type == 'Info') {
      icon = Icons.info_outline_rounded;
      iconColor = Colors.blueAccent;
    } else {
      icon = Icons.settings_system_daydream;
      iconColor = AppTheme.primary;
    }

    final timeString = DateFormat('MMM d, h:mm a').format(notif.timestamp);

    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppTheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: AppTheme.surface),
      ),
      onDismissed: (_) {
        provider.removeNotification(notif.id);
      },
      child: InkWell(
        onTap: () {
          if (!notif.isRead) {
            provider.markAsRead(notif.id);
          }
        },
        child: Container(
          color: notif.isRead ? Colors.transparent : AppTheme.primary.withOpacity(0.05),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: AppTextStyles.titleMd.copyWith(
                              fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800,
                              color: notif.isRead ? AppTheme.onSurface.withOpacity(0.8) : AppTheme.onSurface,
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif.message,
                      style: AppTextStyles.bodyMd.copyWith(
                        color: notif.isRead ? AppTheme.onSurface.withOpacity(0.6) : AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      timeString,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppTheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
