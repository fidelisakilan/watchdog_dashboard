import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/modules/home/bloc/camera_bloc.dart';
import 'package:watchdog_dashboard/modules/home/ui/video_preview_screen.dart';
import 'package:watchdog_dashboard/tiles/dynamic_timeline_tile_flutter.dart';
import 'package:watchdog_dashboard/widgets/loading_widget.dart';
import '../../../widgets/divider.dart';

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text('Timeline'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.logout,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const DividerWidget(),
        const Expanded(
          child: TimelinePromptWidget(),
        ),
      ],
    );
  }
}

class TimelinePromptWidget extends StatefulWidget {
  const TimelinePromptWidget({super.key});

  @override
  State<TimelinePromptWidget> createState() => _TimelinePromptWidgetState();
}

class _TimelinePromptWidgetState extends State<TimelinePromptWidget> {
  final CameraBloc bloc = CameraBloc.instance;

  @override
  void initState() {
    super.initState();
    bloc.loadData();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  String parseDate(DateTime date) {
    return "${DateFormat.Md().format(date)}\n${date.year}";
  }

  String parseTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CameraModel>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingWidget(),
            ],
          );
        }

        return LayoutBuilder(builder: (context, constraints) {
          int cIndex = snapshot.data!.index;
          return Padding(
            padding: EdgeInsets.only(right: constraints.maxWidth * 0.25),
            child: SingleChildScrollView(
              child: MultiDynamicTimelineTileBuilder(
                itemCount: snapshot.data!.cameras[cIndex].length,
                itemBuilder: (context, index) {
                  final model = snapshot.data!.cameras[cIndex][index];
                  return MultiDynamicTimelineTile(
                    crossSpacing: 15,
                    mainSpacing: 8,
                    indicatorRadius: 6,
                    indicatorWidth: 1,
                    starerChild: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Text(
                          parseDate(model.date),
                          style: context.textTheme.labelSmall,
                        ),
                      )
                    ],
                    eventsList: [
                      model.chats.map((chat) {
                        return EventCard(
                          cardRadius: BorderRadius.circular(20),
                          cardColor: chat.flagged
                              ? context.colorScheme.errorContainer
                              : context.colorScheme.surfaceContainer,
                          child: CustomEventTile2(
                            title: parseTime(chat.timeStamp),
                            description: chat.content,
                            videoUrl: chat.videoUrl,
                          ),
                        );
                      }).toList()
                    ],
                  );
                },
              ),
            ),
          );
        });
      },
    );
  }
}

class DateTranscriptionModel {
  final DateTime date;
  final List<TranscriptionModel> chats;

  DateTranscriptionModel({required this.date, required this.chats});
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
}

class CustomEventTile2 extends StatelessWidget {
  final String title;
  final String description;
  final String? videoUrl;

  const CustomEventTile2({
    super.key,
    required this.title,
    required this.description,
    this.videoUrl,
  });

  void onTap(BuildContext context, String videoUrl) {
    context.push(VideoPreviewScreen(url: videoUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textTheme.labelMedium),
              GestureDetector(
                onTap: () {
                  const snackBar = SnackBar(content: Text('Copied Text'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Clipboard.setData(ClipboardData(text: description));
                },
                child: Text(
                  description,
                  style: context.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        if (videoUrl != null)
          GestureDetector(
            onTap: () {
              onTap(context, videoUrl!);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.black,
              ),
              width: 50,
              height: 50,
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
