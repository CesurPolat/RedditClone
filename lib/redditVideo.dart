import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class redditVideo extends StatefulWidget {
  const redditVideo({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<redditVideo> createState() => _redditVideoState();
}

class _redditVideoState extends State<redditVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    //_controller.setVolume(0.0);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 0.0),
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  //_ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
