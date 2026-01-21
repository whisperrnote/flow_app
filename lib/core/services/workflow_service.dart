import 'package:appwrite/appwrite.dart';
import '../constants/appwrite_constants.dart';
import 'appwrite_service.dart';
import '../models/task_model.dart';

class WorkflowService {
  final Databases _databases = AppwriteService().databases;

  Future<List<Task>> listTasks(String userId) async {
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
          'userId': userId,
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
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
        data: {'status': status, 'updatedAt': DateTime.now().toIso8601String()},
      );
    } catch (e) {
      throw Exception('Failed to update task status: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _databases.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tasksCollectionId,
        documentId: taskId,
      );
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
