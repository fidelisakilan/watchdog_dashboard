import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:watchdog_dashboard/modules/home/model/camera_model.dart';
import 'package:watchdog_dashboard/modules/home/utils.dart';

class CameraBloc {
  static CameraBloc get instance => _instance ??= CameraBloc._();

  static CameraBloc? _instance;

  CameraBloc._();

  final BehaviorSubject<CameraModel> _subject = BehaviorSubject<CameraModel>();

  Stream<CameraModel> get stream => _subject.stream;

  final BehaviorSubject<List<AlertChatModel>> _alertSubject =
      BehaviorSubject<List<AlertChatModel>>();

  Stream<List<AlertChatModel>> get alertStream => _alertSubject.stream;

  CameraModel cameraModel = CameraModel(cameras: [{}, {}], index: 0);

  final db = FirebaseFirestore.instance;

  StreamSubscription? _subscription1;
  StreamSubscription? _subscription2;

  void loadData() async {
    _subscription1 = db
        .collection("cam0")
        .snapshots()
        .listen((event) => _loadData(event.docs, 0));
    _subscription2 = db
        .collection("cam1")
        .snapshots()
        .listen((event) => _loadData(event.docs, 1));
  }

  void _loadData(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots, int index) {
    for (var element in snapshots) {
      final transcript = TranscriptionModel.fromMap(element.data());
      final date = DateFormatUtils.parseDate(transcript.timeStamp);
      if (cameraModel.cameras[index].containsKey(date)) {
        cameraModel.cameras[index][date]!.add(transcript);
      } else {
        cameraModel.cameras[index][date] = [transcript];
      }
    }
    _subject.sink.add(cameraModel);
    _updateAlerts();
  }

  void _updateAlerts() {
    final List<AlertChatModel> alerts = [];
    for (var element in cameraModel.cameras) {
      element.forEach(
        (key, value) {
          for (var element2 in value) {
            if (element2.flagged) {
              alerts.add(AlertChatModel(
                chatModel: element2,
                index: (element == cameraModel.cameras[0]) ? 0 : 1,
              ));
            }
          }
        },
      );
    }
    _alertSubject.add(alerts);
  }

  void changeIndex(int index) {
    _subject.sink.add(cameraModel.copyWith(index: index));
  }

  void dispose() {
    _alertSubject.close();
    _subscription1?.cancel();
    _subscription2?.cancel();
    _subject.close();
  }
}
