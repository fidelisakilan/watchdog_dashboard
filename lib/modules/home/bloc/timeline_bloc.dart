import 'package:rxdart/rxdart.dart';
import 'package:watchdog_dashboard/bloc_Interface.dart';

import '../ui/timeline_widget.dart';

class TimelineBloc implements BlocInterface {
  final BehaviorSubject<List<DateTranscriptionModel>> subject =
      BehaviorSubject<List<DateTranscriptionModel>>();

  Stream<List<DateTranscriptionModel>> get stream => subject.stream;

  void loadData() {
    List<DateTranscriptionModel> texts = [
      DateTranscriptionModel(
        date: DateTime.now().subtract(const Duration(days: 1)),
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
            content: 'Man with a bag signing a form',
          ),
        ],
      ),
    ];

    subject.sink.add(texts);
  }

  @override
  void dispose() {
    subject.close();
  }
}
