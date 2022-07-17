import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;

  const CustomVideoPlayer({
    required this.video,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController controller;

  // initState는 initializeController를 호출만하고 끝난다
  // 비동기처리는 initializeController() 함수가 처리함.
  @override
  void initState() {
    super.initState();

    initializeController();
  }

  initializeController() async {
    controller = VideoPlayerController.file(
      File(widget.video.path),
    );

    await controller.initialize();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const CircularProgressIndicator();
    }

    return Stack(
      //alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(
            controller,
          ),
        ),
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: _Controls(
            onReversePressed: onReversePressed,
            onForwardPressed: onForwardPressed,
            onPlayPressed: onPlayPressed,
            isplaying: controller.value.isPlaying,
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            onPressed: () {},
            color: Colors.white,
            iconSize: 30.0,
            icon: Icon(Icons.photo_camera_back),
          ),
        ),
      ],
    );
  }

  void onReversePressed() {
    final currentPosition = controller.value.position;
    Duration position = Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    controller.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = controller.value.duration;
    final currentPosition = controller.value.position;

    Duration position = maxPosition;

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    controller.seekTo(position);
  }

  void onPlayPressed() {
    // 이미 실행중이면 중지
    //실행중이 아니면 실행
    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    });
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversePressed;
  final VoidCallback onForwardPressed;
  final bool isplaying;

  const _Controls({
    required this.onPlayPressed,
    required this.onForwardPressed,
    required this.onReversePressed,
    required this.isplaying,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
            onPressed: onReversePressed,
            iconData: Icons.rotate_left,
          ),
          renderIconButton(
            onPressed: onPlayPressed,
            iconData: isplaying ? Icons.pause : Icons.play_arrow,
          ),
          renderIconButton(
            onPressed: onForwardPressed,
            iconData: Icons.rotate_right,
          ),
        ],
      ),
    );
  }

  Widget renderIconButton({
    required VoidCallback onPressed,
    required IconData iconData,
  }) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
      icon: Icon(iconData),
    );
  }
}
