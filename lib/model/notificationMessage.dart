// ignore_for_file: file_names

class NotificationModel {
  final String title;
  final String body;
  final Map<String, dynamic> payload;

  NotificationModel({
    required this.title,
    required this.body,
    required this.payload,
  });
}
