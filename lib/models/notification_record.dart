import 'dart:convert';

/// Model class representing a notification record in history.
class NotificationRecord {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final DateTime timestamp;
  final String type;
  final bool wasRead;

  NotificationRecord({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    required this.timestamp,
    required this.type,
    this.wasRead = false,
  });

  /// Create a copy with modified fields.
  NotificationRecord copyWith({
    int? id,
    String? title,
    String? body,
    String? payload,
    DateTime? timestamp,
    String? type,
    bool? wasRead,
  }) {
    return NotificationRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      wasRead: wasRead ?? this.wasRead,
    );
  }

  /// Convert to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'wasRead': wasRead,
    };
  }

  /// Create from JSON map.
  factory NotificationRecord.fromJson(Map<String, dynamic> json) {
    return NotificationRecord(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      payload: json['payload'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      wasRead: json['wasRead'] as bool? ?? false,
    );
  }

  /// Convert to JSON string.
  String toJsonString() => jsonEncode(toJson());

  /// Create from JSON string.
  factory NotificationRecord.fromJsonString(String jsonString) {
    return NotificationRecord.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }

  @override
  String toString() {
    return 'NotificationRecord(id: $id, title: $title, type: $type, wasRead: $wasRead)';
  }
}
