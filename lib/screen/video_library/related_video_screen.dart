import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/video_library_viewModel/recent_video_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../model/response_model/video_library_response_model/recent_video_response_model.dart';

class RelatedVideoScreen extends StatefulWidget {
  final int id;
  final List<RecentVideo> data;
  RelatedVideoScreen({Key? key, required this.id, required this.data})
      : super(key: key);

  @override
  _RelatedVideoScreenState createState() => _RelatedVideoScreenState();
}

class _RelatedVideoScreenState extends State<RelatedVideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late YoutubePlayerController _youTubePlayerController;
  ChewieController? _chewieController;
  RecentVideoViewModel _recentVideoViewModel = Get.put(RecentVideoViewModel());

  @override
  void initState() {
    super.initState();

    print(
        "-=-=-=-=-=-=-=-=-=- ${widget.data[widget.id].videoId} ----------- ${widget.data[widget.id].categoryId}");

    initializePlayer();
  }

  @override
  void dispose() {
    if ('${widget.data[widget.id].videoUrl}'.contains('www.youtube.com')) {
      _youTubePlayerController.dispose();
    } else {
      _videoPlayerController.dispose();
      _chewieController?.dispose();
    }

    super.dispose();
  }

  Future<void> initializePlayer() async {
    if ('${widget.data[widget.id].videoUrl}'.contains('www.youtube.com')) {
      _youTubePlayerController = YoutubePlayerController(
        initialVideoId: youtubeVideoID(),
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          controlsVisibleAtStart: true,
          hideControls: false,
          loop: true,
        ),
      );
      log('playing youtube video -- -- -- -- ${widget.data[widget.id].videoUrl}');
    } else {
      _videoPlayerController =
          VideoPlayerController.network('${widget.data[widget.id].videoUrl}');

      log('playing network video == == == == ${widget.data[widget.id].videoUrl}');
      await Future.wait([
        _videoPlayerController.initialize(),
      ]);
      _createChewieController();
    }
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: true,
      showControlsOnInitialize: true,
      hideControlsTimer: const Duration(hours: 5),
    );
  }

  int currPlayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return '${widget.data[widget.id].videoUrl}'.contains('www.youtube.com')
        ? YoutubePlayerBuilder(
            onExitFullScreen: () {},
            player: YoutubePlayer(
              controller: _youTubePlayerController,
              showVideoProgressIndicator: true,
              width: Get.width,
              progressIndicatorColor: ColorUtils.kTint,
              progressColors: ProgressBarColors(
                  handleColor: ColorUtils.kRed,
                  playedColor: ColorUtils.kRed,
                  backgroundColor: ColorUtils.kGray,
                  bufferedColor: ColorUtils.kLightGray),
            ),
            builder: (context, player) {
              return Scaffold(
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
                  title: Text('Video Library',
                      style: FontTextStyle.kWhite16BoldRoboto),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                          height: Get.height / 3,
                          width: Get.width,
                          child: Center(
                            child: _youTubePlayerController != null ||
                                    _youTubePlayerController != ''
                                ? player
                                : Center(
                                    child: CircularProgressIndicator(
                                    color: ColorUtils.kTint,
                                  )),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 0,
                            left: Get.width * .06,
                            right: Get.width * .06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.data[widget.id].videoTitle}',
                                style: FontTextStyle.kWhite17BoldRoboto),
                            SizedBox(height: Get.height * .008),
                            htmlToText(
                                data: widget.data[widget.id].videoDescription),
                            SizedBox(height: Get.height * .02),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        : '${widget.data[widget.id].videoUrl}'.contains('https://vimeo.com/')
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
                  title: Text('Video Library',
                      style: FontTextStyle.kWhite16BoldRoboto),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        height: Get.height / 2.75,
                        width: Get.width,
                        child: Center(
                            child: VimeoVideoPlayer(
                          vimeoPlayerModel: VimeoPlayerModel(
                            url: widget.data[widget.id].videoUrl!,
                            deviceOrientation: DeviceOrientation.portraitUp,
                            systemUiOverlay: const [
                              SystemUiOverlay.top,
                              SystemUiOverlay.bottom,
                            ],
                          ),
                        )),
                      ),
                      SizedBox(height: Get.height * .008),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Get.height * 0.008,
                            left: Get.width * .06,
                            right: Get.width * .06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.data[widget.id].videoTitle}',
                                style: FontTextStyle.kWhite17BoldRoboto),
                            SizedBox(height: Get.height * .008),
                            htmlToText(
                                data: widget.data[widget.id].videoDescription),
                            SizedBox(height: Get.height * .02),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Scaffold(
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
                  title: Text('Video Library',
                      style: FontTextStyle.kWhite16BoldRoboto),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        height: Get.height / 2.75,
                        width: Get.width,
                        child: Center(
                          child: _chewieController != null &&
                                  _chewieController!
                                      .videoPlayerController.value.isInitialized
                              ? Chewie(
                                  controller: _chewieController!,
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                  color: ColorUtils.kTint,
                                )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: Get.height * 0.008,
                            left: Get.width * .06,
                            right: Get.width * .06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.data[widget.id].videoTitle}',
                                style: FontTextStyle.kWhite17BoldRoboto),
                            SizedBox(height: Get.height * .008),
                            htmlToText(
                                data: widget.data[widget.id].videoDescription),
                            SizedBox(height: Get.height * .02),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
  }

  youtubeVideoID() {
    String finalLink;
    String videoID = '${widget.data[widget.id].videoUrl}';
    List<String> splittedLink = videoID.split('v=');
    List<String> longLink = splittedLink.last.split('&');
    log('long video id ------------- == > $longLink');
    finalLink = longLink.first;
    log('final video id ------------ == > $finalLink');
    return finalLink;
  }
}
