class FocusSession {
  final String id;
  final String userId;
  final String taskId;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration;
  final String status;
  final String? originSpotifyContext;
  final DateTime createdAt;
  final DateTime updatedAt;

  FocusSession({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.status,
    this.originSpotifyContext,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      id: json['\$id'] ?? '',
      userId: json['userId'] ?? '',
      taskId: json['taskId'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      duration: json['duration'] ?? 0,
      status: json['status'] ?? 'active',
      originSpotifyContext: json['originSpotifyContext'],
      createdAt: DateTime.parse(json['\$createdAt']),
      updatedAt: DateTime.parse(json['\$updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'taskId': taskId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'status': status,
      'originSpotifyContext': originSpotifyContext,
    };
  }
}
