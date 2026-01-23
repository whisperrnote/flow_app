import 'package:appwrite/appwrite.dart';
import '../constants/appwrite_constants.dart';
import 'appwrite_service.dart';
import '../models/task_model.dart';
import '../models/calendar_model.dart';
import '../models/event_model.dart';
import '../models/focus_session_model.dart';
import '../constants/app_constants.dart';

class WorkflowService {
  final Databases _databases = AppwriteService().databases;

  // Tasks
  Future<List<Task>> listTasks(String userId) async {
    if (AppConstants.useMockMode) {
      return [
        Task(
          id: '1',
          title: 'Complete Project Documentation',
          description: 'Write up all the docs.',
          status: 'pending',
          priority: 'high',
          userId: userId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tasksCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.orderDesc('\$createdAt'),
        ],
      );
      return response.documents.map((doc) => Task.fromJson(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to list tasks: $e');
    }
  }

  Future<Task> createTask({
    required String userId,
    required String title,
    required String description,
    required String status,
    required String priority,
    DateTime? dueDate,
    String? recurrenceRule,
    List<String>? tags,
    String? parentId,
  }) async {
    try {
      final doc = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tasksCollectionId,
        documentId: ID.unique(),
        data: {
          'title': title,
          'description': description,
          'status': status,
          'priority': priority,
          'dueDate': dueDate?.toIso8601String(),
          'recurrenceRule': recurrenceRule,
          'tags': tags,
          'userId': userId,
          'parentId': parentId,
        },
        permissions: [
          Permission.read(Role.user(userId)),
          Permission.update(Role.user(userId)),
          Permission.delete(Role.user(userId)),
        ],
      );
      return Task.fromJson(doc.data);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<void> updateTaskStatus(String taskId, String status) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tasksCollectionId,
        documentId: taskId,
        data: {'status': status},
      );
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }

  // Calendars
  Future<List<Calendar>> listCalendars(String userId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.calendarsCollectionId,
        queries: [Query.equal('userId', userId)],
      );
      return response.documents
          .map((doc) => Calendar.fromJson(doc.data))
          .toList();
    } catch (e) {
      throw Exception('Failed to list calendars: $e');
    }
  }

  // Events
  Future<List<Event>> listEvents(String userId) async {
    if (AppConstants.useMockMode) {
      return [
        Event(
          id: '1',
          calendarId: 'default',
          title: 'Mock Meeting',
          description: 'A mock meeting description.',
          visibility: 'public',
          status: 'confirmed',
          startTime: DateTime.now().add(const Duration(hours: 2)),
          endTime: DateTime.now().add(const Duration(hours: 3)),
          userId: userId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.eventsCollectionId,
        queries: [Query.equal('userId', userId)],
      );
      return response.documents.map((doc) => Event.fromJson(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to list events: $e');
    }
  }

  // Focus Sessions
  Future<FocusSession> startFocusSession({
    required String userId,
    required String taskId,
    required int duration,
  }) async {
    try {
      final doc = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.focusSessionsCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': userId,
          'taskId': taskId,
          'startTime': DateTime.now().toIso8601String(),
          'duration': duration,
          'status': 'active',
        },
        permissions: [
          Permission.read(Role.user(userId)),
          Permission.update(Role.user(userId)),
        ],
      );
      return FocusSession.fromJson(doc.data);
    } catch (e) {
      throw Exception('Failed to start focus session: $e');
    }
  }

  Future<void> endFocusSession(String sessionId) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.focusSessionsCollectionId,
        documentId: sessionId,
        data: {
          'endTime': DateTime.now().toIso8601String(),
          'status': 'completed',
        },
      );
    } catch (e) {
      throw Exception('Failed to end focus session: $e');
    }
  }
}
