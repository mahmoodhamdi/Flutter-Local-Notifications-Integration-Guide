import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_feature/helpers/notification_helper.dart';
import 'package:flutter_local_notifications_feature/helpers/show_snack_bar_helper.dart';

/// Page to display and manage pending (scheduled) notifications.
class PendingNotificationsPage extends StatefulWidget {
  const PendingNotificationsPage({super.key});

  @override
  State<PendingNotificationsPage> createState() =>
      _PendingNotificationsPageState();
}

class _PendingNotificationsPageState extends State<PendingNotificationsPage> {
  List<PendingNotificationRequest> _pendingNotifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingNotifications();
  }

  Future<void> _loadPendingNotifications() async {
    setState(() => _isLoading = true);

    final notifications = await NotificationHelper.getPendingNotifications();

    setState(() {
      _pendingNotifications = notifications;
      _isLoading = false;
    });
  }

  Future<void> _cancelNotification(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Notification'),
        content: Text('Are you sure you want to cancel notification #$id?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await NotificationHelper.cancelNotification(id);
      if (mounted) {
        showSnackBar(
          context: context,
          message: 'Notification #$id canceled',
        );
      }
      await _loadPendingNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Pending Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingNotifications,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingNotifications.isEmpty
              ? _buildEmptyState()
              : _buildNotificationList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Pending Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Schedule a notification to see it here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return RefreshIndicator(
      onRefresh: _loadPendingNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingNotifications.length,
        itemBuilder: (context, index) {
          final notification = _pendingNotifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(PendingNotificationRequest notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'ID: ${notification.id}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _cancelNotification(notification.id),
                  tooltip: 'Cancel this notification',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              notification.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notification.body ?? 'No Body',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (notification.payload != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.data_object, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        notification.payload!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
