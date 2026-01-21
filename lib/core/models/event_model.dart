class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String? meetingUrl;
  final String visibility;
  final String status;
  final String? coverImageId;
  final int? maxAttendees;
  final String? recurrenceRule;
  final String calendarId;
  final String userId;
  final bool? isCampGated;
  final String? campIpNftTokenId;
  final bool? campMinteable;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.meetingUrl,
    required this.visibility,
    required this.status,
    this.coverImageId,
    this.maxAttendees,
    this.recurrenceRule,
    required this.calendarId,
    required this.userId,
    this.isCampGated,
    this.campIpNftTokenId,
    this.campMinteable,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['\$id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      meetingUrl: json['meetingUrl'],
      visibility: json['visibility'] ?? 'public',
      status: json['status'] ?? 'confirmed',
      coverImageId: json['coverImageId'],
      maxAttendees: json['maxAttendees'],
      recurrenceRule: json['recurrenceRule'],
      calendarId: json['calendarId'] ?? '',
      userId: json['userId'] ?? '',
      isCampGated: json['isCampGated'],
      campIpNftTokenId: json['campIpNftTokenId'],
      campMinteable: json['campMinteable'],
      createdAt: DateTime.parse(json['\$createdAt']),
      updatedAt: DateTime.parse(json['\$updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'meetingUrl': meetingUrl,
      'visibility': visibility,
      'status': status,
      'coverImageId': coverImageId,
      'maxAttendees': maxAttendees,
      'recurrenceRule': recurrenceRule,
      'calendarId': calendarId,
      'userId': userId,
      'isCampGated': isCampGated,
      'campIpNftTokenId': campIpNftTokenId,
      'campMinteable': campMinteable,
    };
  }
}
