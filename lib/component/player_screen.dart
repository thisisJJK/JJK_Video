import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jjk_video/screen/home_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:jjk_video/component/player_button.dart';
import 'dart:io';

class JVP extends StatefulWidget {
  final XFile video;
  final GestureTapCallback newVideo;
  const JVP({
    required this.video,
    required this.newVideo,
    super.key,
  });

  @override
  State<JVP> createState() => _JVPState();
}

class _JVPState extends State<JVP> {
  bool showControls = false;

  VideoPlayerController? videoController;

  @override
  void didUpdateWidget(covariant JVP oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  void initState() {
    super.initState();
    initializeController();
  }

  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );
    await videoController.initialize();

    videoController.addListener(videoControllerListner);

    setState(() {
      this.videoController = videoController;
    });
  }

  void videoControllerListner() {
    setState(() {});
  }

  @override
  void dispose() {
    videoController!.removeListener(videoControllerListner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
              videoController!,
            ),
            if (showControls)
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
            if (showControls)
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        renderTime(videoController!.value.position),
                        Expanded(
                          child: Slider(
                            onChanged: (double val) {
                              videoController!
                                  .seekTo(Duration(seconds: val.toInt()));
                            },
                            value: videoController!.value.position.inSeconds
                                .toDouble(),
                            min: 0,
                            max: videoController!.value.duration.inSeconds
                                .toDouble(),
                          ),
                        ),
                        renderTime(videoController!.value.duration),
                        SizedBox(
                          width: 8,
                        )
                      ],
                    ),
                  )),

            //뒤로가기 버튼 누르면 첫 홈화면 가고싶음
            if (showControls)
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {},
                ),
              ),
            if (showControls)
              Align(
                alignment: Alignment.topRight,
                child: PlayerButton(
                  iconData: Icons.photo_camera_back,
                  onPressed: widget.newVideo,
                ),
              ),
            if (showControls)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PlayerButton(
                        iconData: Icons.rotate_left, onPressed: reversePressed),
                    PlayerButton(
                        iconData: videoController!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        onPressed: playPressed),
                    PlayerButton(
                        iconData: Icons.rotate_right, onPressed: fowardPressed),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  void reversePressed() {
    final currentPosition = videoController!.value.position;
    Duration position = Duration();
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  void playPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }

  void fowardPressed() {
    final currentPosition = videoController!.value.position;
    final maxPosition = videoController!.value.duration;
    Duration position = Duration();

    if ((maxPosition.inSeconds - currentPosition.inSeconds) > 3) {
      position = currentPosition + Duration(seconds: 3);
    }
    videoController!.seekTo(position);
  }

  Widget renderTime(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: TextStyle(color: Colors.white),
    );
  }
}
