import 'package:watchdog_dashboard/config.dart';

import 'timeline_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          CameraSelectorRowWidget(),
          Expanded(
            child: TimelineWidget(),
          ),
          AlertWindowWidget(),
        ],
      ),
    );
  }
}

class CameraSelectorRowWidget extends StatelessWidget {
  const CameraSelectorRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      color: context.colorScheme.surfaceContainer,
      child: ListView.separated(
        itemCount: 5,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        separatorBuilder: (context, index) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          return AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.surface,
              ),
            ),
          );
        },
      ),
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
