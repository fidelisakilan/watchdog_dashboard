import 'package:intl/intl.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/modules/home/bloc/timeline_bloc.dart';
import 'package:watchdog_dashboard/tiles/dynamic_timeline_tile_flutter.dart';
import 'package:watchdog_dashboard/widgets/loadingwidget.dart';

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
  final TimelineBloc bloc = TimelineBloc();

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
    return StreamBuilder<List<DateTranscriptionModel>>(
      stream: bloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Loadingwidget();
        }

        return LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.only(right: constraints.maxWidth * 0.25),
            child: SingleChildScrollView(
              child: MultiDynamicTimelineTileBuilder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final model = snapshot.data![index];
                  return MultiDynamicTimelineTile(
                    crossSpacing: 15,
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
                          cardColor: Colors.grey,
                          child: CustomEventTile2(
                            title: parseTime(chat.timeStamp),
                            description: chat.content,
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
  final bool flagged;

  TranscriptionModel({
    required this.content,
    required this.timeStamp,
    this.flagged = false,
    this.videoUrl,
  });
}

class CustomEventTile2 extends StatelessWidget {
  final String title;
  final String description;

  const CustomEventTile2({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.labelMedium),
        Text(
          description,
          style: context.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
