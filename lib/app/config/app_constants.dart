class AppConstants {
  static const String appName = 'WhatsApp';
  static const String appVersion = '1.0.0';

  // Storage keys & Hive boxes
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';
  static const String chatCacheBox = 'chat_cache_box';

  // Default Assets / Fallbacks
  static const String defaultAvatarUrl = 'https://picsum.photos/200';
  static const String defaultGroupAvatarUrl = 'https://picsum.photos/201';

  // Call Signaling Types
  static const String callTypeAudio = 'AUDIO';
  static const String callTypeVideo = 'VIDEO';
  static const String callStatusOutgoing = 'OUTGOING';
  static const String callStatusIncoming = 'INCOMING';
  static const String callStatusMissed = 'MISSED';
  static const String callStatusConnected = 'CONNECTED';
  static const String callStatusEnded = 'ENDED';

  // Message Types
  static const String msgTypeText = 'text';
  static const String msgTypeImage = 'image';
  static const String msgTypeVideo = 'video';
  static const String msgTypeAudio = 'audio';
  static const String msgTypeDocument = 'document';
  static const String msgTypeLocation = 'location';

  // Status Types
  static const String statusTypeText = 'text';
  static const String statusTypeImage = 'image';
  static const String statusTypeVideo = 'video';
}
