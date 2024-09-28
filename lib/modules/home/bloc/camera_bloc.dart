import 'package:rxdart/rxdart.dart';

import '../ui/timeline_widget.dart';

class CameraBloc {
  static CameraBloc get instance => _instance ??= CameraBloc._();

  static CameraBloc? _instance;

  CameraBloc._();

  final BehaviorSubject<CameraModel> _subject = BehaviorSubject<CameraModel>();

  Stream<CameraModel> get stream => _subject.stream;

  final BehaviorSubject<List<AlertChatModel>> _alertSubject =
      BehaviorSubject<List<AlertChatModel>>();

  Stream<List<AlertChatModel>> get alertStream => _alertSubject.stream;

  CameraModel cameraModel = CameraModel(cameras: cameras, index: 0);

  void loadData() {
    _subject.sink.add(cameraModel);

    final List<AlertChatModel> alerts = [];
    for (var element in cameraModel.cameras) {
      for (var element1 in element) {
        for (var element2 in element1.chats) {
          if (element2.flagged) {
            alerts.add(AlertChatModel(
              chatModel: element2,
              index: (element == cameraModel.cameras[0]) ? 0 : 1,
              chatIndex: element.indexOf(element1),
            ));
          }
        }
      }
    }
    _alertSubject.add(alerts);

    _subject.sink.add(cameraModel);
  }

  void changeIndex(int index) {
    _subject.sink.add(cameraModel.copyWith(index: index));
  }

  void dispose() {
    _alertSubject.close();
    _subject.close();
  }
}

class AlertChatModel {
  final TranscriptionModel chatModel;
  final int index;
  final int chatIndex;

  AlertChatModel({
    required this.chatModel,
    required this.index,
    required this.chatIndex,
  });
}

class CameraModel {
  final List<List<DateTranscriptionModel>> cameras;
  final int index;

  CameraModel({required this.cameras, required this.index});

  CameraModel copyWith({
    List<List<DateTranscriptionModel>>? cameras,
    int? index,
  }) {
    return CameraModel(
      cameras: cameras ?? this.cameras,
      index: index ?? this.index,
    );
  }
}

final cameras = [
  [
    DateTranscriptionModel(
      date: DateTime.now().subtract(const Duration(days: 5)),
      chats: [
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man with a bag signing a form',
        ),
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man with a bag signing a form',
        ),
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man with a bag signing a form',
        ),
      ],
    ),
    DateTranscriptionModel(
      date: DateTime.now().subtract(const Duration(days: 1)),
      chats: [
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man pointing gun at another person',
          flagged: true,
          videoUrl:
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man with a bag signing a form',
        ),
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man with a bag signing a form',
        ),
      ],
    ),
  ],
  [
    DateTranscriptionModel(
      date: DateTime.now().subtract(const Duration(days: 1)),
      chats: [
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man with a bag signing a form',
        ),
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man pointing gun at another person',
          flagged: true,
          videoUrl:
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man with a bag signing a form',
        ),
      ],
    ),
    DateTranscriptionModel(
      date: DateTime.now(),
      chats: [
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man with a bag signing a form',
        ),
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man with a bag signing a form',
        ),
        TranscriptionModel(
          timeStamp: DateTime.now(),
          content: 'Man pointing gun at another person',
          flagged: true,
          videoUrl:
              'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        ),
      ],
    ),
  ]
];
