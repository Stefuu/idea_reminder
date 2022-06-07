import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({Key? key, required this.videoPath})
      : super(key: key);
  final String videoPath;

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool _controllerInitialized = false;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoPath)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controllerInitialized = true;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? Column(
              children: [
                InkWell(
                  onTap: () {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                      setState(() {
                        _isPlaying = !_controller.value.isPlaying;
                      });
                    } else {
                      _controller.play();
                      setState(() {
                        _isPlaying = !_controller.value.isPlaying;
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: SizedBox(
                          height: 500,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'This idea is here since: ${_getDate(widget.videoPath)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                )
              ],
            )
          : Container(),
    );
  }

  _getDate(String path) {
    final int timestamp = int.parse(path.split('Videos/')[1].split('.')[0]);
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return date.toString().split(' ')[0];
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
