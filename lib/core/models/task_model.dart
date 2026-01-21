class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final String? recurrenceRule;
  final List<String>? tags;
  final List<String>? assigneeIds;
  final List<String>? attachmentIds;
  final String? eventId;
  final String userId;
  final String? parentId;
  final String? socialHandle;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    this.recurrenceRule,
    this.tags,
    this.assigneeIds,
    this.attachmentIds,
    this.eventId,
    required this.userId,
    this.parentId,
    this.socialHandle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['\$id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      priority: json['priority'] ?? 'medium',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      recurrenceRule: json['recurrenceRule'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      assigneeIds: json['assigneeIds'] != null
          ? List<String>.from(json['assigneeIds'])
          : null,
      attachmentIds: json['attachmentIds'] != null
          ? List<String>.from(json['attachmentIds'])
          : null,
      eventId: json['eventId'],
      userId: json['userId'] ?? '',
      parentId: json['parentId'],
      socialHandle: json['socialHandle'],
      createdAt: DateTime.parse(json['\$createdAt']),
      updatedAt: DateTime.parse(json['\$updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'recurrenceRule': recurrenceRule,
      'tags': tags,
      'assigneeIds': assigneeIds,
      'attachmentIds': attachmentIds,
      'eventId': eventId,
      'userId': userId,
      'parentId': parentId,
      'socialHandle': socialHandle,
    };
  }
}
