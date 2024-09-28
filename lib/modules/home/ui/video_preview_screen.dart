import 'package:video_player/video_player.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/widgets/loading_widget.dart';

class VideoPreviewScreen extends StatefulWidget {
  const VideoPreviewScreen({super.key, required this.url});

  final String url;

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late VideoPlayerController _controller;

  final GlobalKey _videoPlayerKey = GlobalKey(debugLabel: "Video Player Key");

  Size? get playDimens => _videoPlayerKey.currentContext?.size;

  double get seekerPosition => _controller.value.duration.inMilliseconds == 0
      ? 0
      : _controller.value.position.inMilliseconds /
          _controller.value.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _controller.initialize();
    _controller.setLooping(false);
    _controller.play();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [LoadingWidget()],
      );
    }
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          builder: (context, child) {
            if (!_controller.value.isInitialized) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [LoadingWidget()],
              );
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: VideoPlayer(
                          _controller,
                          key: _videoPlayerKey,
                        ),
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: context.pop,
                              child: const Padding(
                                padding: EdgeInsets.all(30),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_controller.value.isPlaying) {
                                        _controller.pause();
                                      } else {
                                        if (seekerPosition == 1) {
                                          _controller.seekTo(Duration.zero);
                                        }
                                        _controller.play();
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(
                                        _controller.value.isPlaying
                                            ? Icons.pause_outlined
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 32,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        thumbShape:
                                            SliderComponentShape.noThumb,
                                        inactiveTrackColor: context
                                            .colorScheme.surface
                                            .withOpacity(0.25),
                                        activeTrackColor:
                                            context.colorScheme.primary,
                                      ),
                                      child: Slider(
                                        onChanged: ((value) {
                                          _controller.seekTo(
                                              _controller.value.duration *
                                                  value);
                                        }),
                                        min: 0,
                                        max: 1,
                                        value: seekerPosition,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${_controller.value.position.inSeconds} ss',
                                    style: context.textTheme.bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          animation: _controller,
        ),
      ),
    );
  }
}