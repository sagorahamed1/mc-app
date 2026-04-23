class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool viewStatus;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.viewStatus,
    required this.createdAt,
  });

  bool get isUnread => !viewStatus;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        message: json['message'] ?? '',
        type: json['type'] ?? '',
        viewStatus: json['viewStatus'] ?? false,
        createdAt:
            DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}
