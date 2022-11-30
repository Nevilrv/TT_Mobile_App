import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'dart:developer' as d;

class ForumVideoScreen extends StatefulWidget {
  final String? video;
  final bool? isPlay;
  final double? height;
  ForumVideoScreen({
    Key? key,
    this.video,
    this.isPlay,
    this.height,
  }) : super(key: key);

  @override
  _ForumVideoScreenState createState() => _ForumVideoScreenState();
}

class _ForumVideoScreenState extends State<ForumVideoScreen> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  @override
  void initState() {
    super.initState();
    _connectivityCheckViewModel.startMonitoring();

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
    return GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
      return control.isOnline
          ? Container(
              height: widget.height ?? Get.height * 0.23,
              width: Get.width,
              // color: Colors.red,
              child: Center(
                child: chewieController != null &&
                        chewieController!
                            .videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: chewieController!,
                      )
                    : Shimmer.fromColors(
                        child: Container(
                          height: widget.height ?? Get.height * 0.23,
                          width: Get.width,
                          color: Colors.white,
                        ),
                        baseColor: Colors.white.withOpacity(0.4),
                        highlightColor: Colors.white.withOpacity(0.2),
                      ),
              ),
            )
          : ConnectionCheckScreen();
    });
  }
}
