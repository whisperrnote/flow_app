class AppwriteConstants {
  static const String endpoint = 'https://fra.cloud.appwrite.io/v1';
  static const String projectId = '67fe9627001d97e37ef3';
  static const String databaseId = '67ff05a9000296822396';

  // Collections
  static const String usersCollectionId = '67ff05c900247b5673d3';
  static const String tasksCollectionId =
      '67ff05f3002502ef239e'; // Linked to Tasks in Flow
  static const String tagsCollectionId = '67ff06280034908cf08a';
  static const String workflowsCollectionId = 'workflows';
  static const String taskHistoryCollectionId = 'taskHistory';
  static const String commentsCollectionId = 'comments';
  static const String reactionsCollectionId = 'reactions';
  static const String activityLogCollectionId = 'activityLog';

  // Buckets
  static const String profilePicturesBucketId = 'profile_pictures';
  static const String notesAttachmentsBucketId = 'notes_attachments';
}
