import 'package:watchdog_dashboard/config.dart';

import '../bloc/camera_bloc.dart';
import 'timeline_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          CameraSelectorRowWidget(),
          Expanded(child: TimelineWidget()),
          AlertWindowWidget(),
        ],
      ),
    );
  }
}

class CameraSelectorRowWidget extends StatefulWidget {
  const CameraSelectorRowWidget({super.key});

  @override
  State<CameraSelectorRowWidget> createState() =>
      _CameraSelectorRowWidgetState();
}

class _CameraSelectorRowWidgetState extends State<CameraSelectorRowWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CameraModel>(
      stream: CameraBloc.instance.stream,
      builder: (context, snapshot) {
        return Container(
          width: 70,
          color: context.colorScheme.surfaceContainer,
          child: ListView.separated(
            itemCount: snapshot.data?.cameras.length ?? 0,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final selected = snapshot.data?.index == index;
              return GestureDetector(
                onTap: () {
                  CameraBloc.instance.changeIndex(index);
                },
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(selected ? 16 : 100),
                      color: selected
                          ? context.colorScheme.inversePrimary
                          : context.colorScheme.surface,
                    ),
                    child: Center(
                      child: Text(
                        "C${index + 1}",
                        style: context.textTheme.titleSmall!.copyWith(
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class AlertWindowWidget extends StatelessWidget {
  const AlertWindowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
      ),
      child: Column(
        children: [
          AppBar(
            title: const Text('Alert Window'),
          ),
        ],
      ),
    );
  }
}
