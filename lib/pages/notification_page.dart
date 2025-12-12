import 'package:flutter/material.dart';

/// Page displayed when a notification is tapped.
class NotificationPage extends StatelessWidget {
  final String? payload;
  final int? notificationId;
  final String? actionId;
  final String? inputText;

  const NotificationPage({
    super.key,
    this.payload,
    this.notificationId,
    this.actionId,
    this.inputText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'Notification Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: Colors.blueGrey[700],
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Notification Received',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Notification ID
                    _buildInfoRow(
                      icon: Icons.tag,
                      label: 'Notification ID',
                      value: notificationId?.toString() ?? 'N/A',
                    ),
                    const SizedBox(height: 12),

                    // Payload
                    _buildInfoRow(
                      icon: Icons.data_object,
                      label: 'Payload',
                      value: payload ?? 'No payload',
                    ),

                    // Action ID (if from action button)
                    if (actionId != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.touch_app,
                        label: 'Action',
                        value: _getActionLabel(actionId!),
                      ),
                    ],

                    // Input text (if from reply action)
                    if (inputText != null && inputText!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.message,
                        label: 'Reply Text',
                        value: inputText!,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Info text
            Center(
              child: Text(
                'You tapped on a notification and were\nnavigated to this page.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),

            const Spacer(),

            // Back button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Go Back',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get human-readable label for action ID.
  String _getActionLabel(String actionId) {
    switch (actionId) {
      case 'reply_action':
        return 'Reply';
      case 'mark_read_action':
        return 'Mark as Read';
      case 'dismiss_action':
        return 'Dismiss';
      default:
        return actionId;
    }
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
