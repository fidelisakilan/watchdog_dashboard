import 'package:flutter/services.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/modules/home/bloc/camera_bloc.dart';
import 'package:watchdog_dashboard/modules/home/ui/video_preview_screen.dart';
import 'package:watchdog_dashboard/tiles/dynamic_timeline_tile_flutter.dart';
import 'package:watchdog_dashboard/widgets/loading_widget.dart';
import '../../../widgets/divider.dart';
import '../model/camera_model.dart';
import '../utils.dart';

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
              onPressed: () {
                //TODO:
              },
              icon: Icon(
                Icons.logout,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        const DividerWidget(),
        const Expanded(child: TimelinePromptWidget()),
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
                  final chats =
                      snapshot.data!.cameras[cIndex].values.elementAt(index);
                  final date =
                      snapshot.data!.cameras[cIndex].keys.elementAt(index);
                  return MultiDynamicTimelineTile(
                    itemCount: chats.length,
                    crossSpacing: 15,
                    mainSpacing: 8,
                    indicatorRadius: 6,
                    indicatorWidth: 1,
                    starerChild: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Text(
                          date,
                          style: context.textTheme.labelSmall,
                        ),
                      )
                    ],
                    eventsList: [
                      chats.map((chat) {
                        return EventCard(
                          cardRadius: BorderRadius.circular(20),
                          cardColor: chat.flagged
                              ? context.colorScheme.errorContainer
                              : context.colorScheme.surfaceContainer,
                          child: CustomEventTile(
                            title: DateFormatUtils.parseTime(chat.timeStamp),
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

class CustomEventTile extends StatelessWidget {
  final String title;
  final String description;
  final String? videoUrl;

  const CustomEventTile({
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
