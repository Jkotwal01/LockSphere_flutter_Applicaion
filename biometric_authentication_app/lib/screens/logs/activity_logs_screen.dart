import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/text_styles.dart';
import '../../../providers/logs_provider.dart';
import '../../../models/log_model.dart';

class ActivityLogsScreen extends StatefulWidget {
  const ActivityLogsScreen({super.key});

  @override
  State<ActivityLogsScreen> createState() => _ActivityLogsScreenState();
}

class _ActivityLogsScreenState extends State<ActivityLogsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LogsProvider>().fetchLogs('esp32_device_01');
    });
  }

  @override
  Widget build(BuildContext context) {
    final logsProvider = context.watch<LogsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Logs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: logsProvider.isLoading && logsProvider.logs.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : RefreshIndicator(
              color: AppTheme.primary,
              backgroundColor: AppTheme.surfaceContainerHighest,
              onRefresh: () => logsProvider.fetchLogs('esp32_device_01'),
              child: logsProvider.logs.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 16, bottom: 40),
                      itemCount: logsProvider.logs.length,
                      itemBuilder: (context, index) {
                        final log = logsProvider.logs[index];
                        return _buildLogTile(log);
                      },
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: AppTheme.onSurface.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text('No activity history yet', style: AppTextStyles.headlineSm),
        ],
      ),
    );
  }

  Widget _buildLogTile(LogModel log) {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    if (log.isSuccess) {
      iconData = log.action == 'Unlocked' ? Icons.lock_open_rounded : Icons.lock_outline_rounded;
      iconColor = log.action == 'Unlocked' ? AppTheme.tertiary : AppTheme.primary;
      bgColor = iconColor.withOpacity(0.15);
    } else if (log.isError) {
      iconData = Icons.gpp_bad_outlined;
      iconColor = AppTheme.error;
      bgColor = AppTheme.error.withOpacity(0.15);
    } else { // warning
      iconData = Icons.battery_alert;
      iconColor = Colors.orange;
      bgColor = Colors.orange.withOpacity(0.15);
    }

    // Standardize datetime formatting
    final DateFormat timeFormat = DateFormat('h:mm a');
    final DateFormat dateFormat = DateFormat('MMM d');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 4),
                Text(timeFormat.format(log.timestamp), style: AppTextStyles.labelSm),
                Text(dateFormat.format(log.timestamp), style: AppTextStyles.labelSm.copyWith(color: AppTheme.onSurface.withOpacity(0.5))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Vertical Timeline Line & Icon
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
                child: Icon(iconData, size: 20, color: iconColor),
              ),
              // Could add a small vertical line here for full timeline effect
            ],
          ),
          const SizedBox(width: 16),
          // Event Details
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    log.action,
                    style: AppTextStyles.titleSm.copyWith(color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 14, color: AppTheme.onSurface.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text(log.userName, style: AppTextStyles.bodyMd.copyWith(color: AppTheme.onSurface.withOpacity(0.6))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.login, size: 14, color: AppTheme.onSurface.withOpacity(0.6)),
                      const SizedBox(width: 4),
                      Text('via ${log.method}', style: AppTextStyles.labelSm),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
