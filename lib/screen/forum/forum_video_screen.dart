import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:developer' as d;
import '../../utils/ColorUtils.dart';

class ForumVideoScreen extends StatefulWidget {
  final String? video;
  final bool? isPlay;

  ForumVideoScreen({
    Key? key,
    this.video,
    this.isPlay,
  }) : super(key: key);

  @override
  _ForumVideoScreenState createState() => _ForumVideoScreenState();
}

class _ForumVideoScreenState extends State<ForumVideoScreen> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  @override
  void initState() {
    super.initState();
    d.log('widget.video!>>>>>>Z${widget.video!}');
    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    d.log('widget.video!>>>>>>Z${widget.video!}');

    videoPlayerController = VideoPlayerController.network(widget.video!);
    await Future.wait([
      videoPlayerController!.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      showControls: true,
      showControlsOnInitialize: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.23,
      width: Get.width,
      // color: Colors.red,
      child: Center(
        child: chewieController != null &&
                chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(
                controller: chewieController!,
              )
            : Center(child: CircularProgressIndicator(color: ColorUtils.kTint)),
      ),
    );
  }
}
