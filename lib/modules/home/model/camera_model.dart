class AlertChatModel {
  final TranscriptionModel chatModel;
  final int index;

  AlertChatModel({
    required this.chatModel,
    required this.index,
  });
}

class CameraModel {
  final List<Map<String, List<TranscriptionModel>>> cameras;
  final int index;

  CameraModel({required this.cameras, required this.index});

  CameraModel copyWith({
    List<Map<String, List<TranscriptionModel>>>? cameras,
    int? index,
  }) {
    return CameraModel(
      cameras: cameras ?? this.cameras,
      index: index ?? this.index,
    );
  }
}

class TranscriptionModel {
  final String content;
  final DateTime timeStamp;
  final String? videoUrl;
  final int? videoOffset;
  final bool flagged;

  TranscriptionModel({
    required this.content,
    required this.timeStamp,
    this.flagged = false,
    this.videoUrl,
    this.videoOffset,
  });

  factory TranscriptionModel.fromMap(Map<String, dynamic> map) {
    return TranscriptionModel(
      content: map['description'] as String,
      timeStamp:
          DateTime.parse((map['timestamp'] as String).replaceAll('.', '')),
      videoUrl: map['video_url'] as String,
      videoOffset: map['offset'] as int,
      flagged: map['threat_level'] as bool,
    );
  }
}
