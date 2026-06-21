enum NotificationType {
  recommendation('RECOMMENDATION', 'Rekomendasi'),
  deviceAlert('DEVICE_ALERT', 'Alert Device'),
  siteInvite('SITE_INVITE', 'Invite Site'),
  taskAssignment('TASK_ASSIGNMENT', 'Tugas Baru'),
  forumInteraction('FORUM_INTERACTION', 'Forum'),
  general('GENERAL', 'Info');

  final String apiValue;
  final String label;
  const NotificationType(this.apiValue, this.label);

  static NotificationType fromApi(String? value) {
    if (value == null) return NotificationType.general;
    final upper = value.toUpperCase();
    for (final type in NotificationType.values) {
      if (type.apiValue == upper) return type;
    }
    return NotificationType.general;
  }
}

class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final String? redirectPath;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.isRead,
    this.redirectPath,
  });

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? body,
    DateTime? timestamp,
    bool? isRead,
    String? redirectPath,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      redirectPath: redirectPath ?? this.redirectPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.apiValue,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'redirectPath': redirectPath,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      type: NotificationType.fromApi(json['type'] as String?),
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      redirectPath: json['redirectPath'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppNotification &&
        other.id == id &&
        other.type == type &&
        other.title == title &&
        other.body == body &&
        other.timestamp == timestamp &&
        other.isRead == isRead &&
        other.redirectPath == redirectPath;
  }

  @override
  int get hashCode => Object.hash(
        id,
        type,
        title,
        body,
        timestamp,
        isRead,
        redirectPath,
      );
}
