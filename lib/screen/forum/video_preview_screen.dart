import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../utils/ColorUtils.dart';

class VideoPreviewScreen extends StatefulWidget {
  final File? video;
  VideoPreviewScreen({Key? key, this.video}) : super(key: key);

  @override
  _VideoPreviewScreenState createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  @override
  void initState() {
    super.initState();
    _connectivityCheckViewModel.startMonitoring();

    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.file(widget.video!);
    await Future.wait([
      videoPlayerController!.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      showControls: true,
      showControlsOnInitialize: true,
    );
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
      return control.isOnline
          ? Scaffold(
              backgroundColor: ColorUtils.kBlack,
              appBar: AppBar(
                elevation: 0,
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: ColorUtils.kTint,
                    )),
                backgroundColor: ColorUtils.kBlack,
              ),
              body: Container(
                child: Center(
                  child: chewieController != null &&
                          chewieController!
                              .videoPlayerController.value.isInitialized
                      ? Chewie(
                          controller: chewieController!,
                        )
                      : Center(
                          child: CircularProgressIndicator(
                              color: ColorUtils.kTint)),
                ),
              ),
            )
          : ConnectionCheckScreen();
    });
  }
}
