class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final String timeAgo;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    this.imageUrl,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    required this.timeAgo,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: json['type'] ?? 'general',
      data: json['data'],
      imageUrl: json['image_url'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      timeAgo: json['time_ago'] ?? '',
    );
  }
}

class NotificationResponse {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final int currentPage;
  final int lastPage;
  final int total;

  NotificationResponse({
    required this.notifications,
    required this.unreadCount,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      notifications: (json['notifications'] as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList(),
      unreadCount: json['unread_count'] ?? 0,
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
    );
  }
}
