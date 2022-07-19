import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/model/response_model/video_library_response_model/all_video_res_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class WatchVideoScreen extends StatefulWidget {
  final int id;
  final List<VideoData> data;

  WatchVideoScreen({required this.id, required this.data});

  @override
  State<WatchVideoScreen> createState() => _WatchVideoScreenState();
}

class _WatchVideoScreenState extends State<WatchVideoScreen> {
  late VideoPlayerController _videoPlayerController;
  late YoutubePlayerController _youTubePlayerController;
  ChewieController? _chewieController;

  // Future<void> _initializeVideoPlayerFuture;
  // VideoByIdViewModel _videoByIdViewModel = Get.put(VideoByIdViewModel());
  // AllVideoViewModel _allVideoViewModel = Get.put(AllVideoViewModel());
  // VideoViewsViewModel _videoViewsViewModel = Get.put(VideoViewsViewModel());
  // VideoLikeViewModel _videoLikeViewModel = Get.put(VideoLikeViewModel());
  // VideoDislikeViewModel _videoDislikeViewModel =
  //     Get.put(VideoDislikeViewModel());

  @override
  void initState() {
    super.initState();
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
    // print('${_videoByIdViewModel.apiResponse.status}');
    // if (_videoByIdViewModel.apiResponse.status == Status.COMPLETE) {}
    // AllVideoResponseModel response = _videoByIdViewModel.apiResponse.data;

    if ('${widget.data[widget.id].videoUrl}'.contains('www.youtube.com')) {
      // String? videoID;
      // videoID =
      //     YoutubePlayer.convertUrlToId('${widget.data[widget.id].videoUrl}');

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

  // _launchURL() async {
  //   if (Platform.isIOS) {
  //     if (await canLaunch(_url)) {
  //       await launch(_url, forceSafariVC: false);
  //     } else {
  //       if (await canLaunch(_url)) {
  //         await launch(_url);
  //       } else {
  //         throw 'Could not launch $_url';
  //       }
  //     }
  //   } else {
  //     if (await canLaunch(_url)) {
  //       await launch(_url);
  //     } else {
  //       throw 'Could not launch $_url';
  //     }
  //   }
  // }
  //
  // videoViews({String? id}) async {
  //   await _videoViewsViewModel.videoViewsViewModel(id: id);
  //   VideoViewsResponseModel responseViews =
  //       _videoViewsViewModel.apiResponse.data;
  //   setState(() {
  //     widget.data[widget.id].videoVisits =
  //         responseViews.data!.totalVisits.toString();
  //     _allVideoViewModel.getVideoDetails();
  //   });
  //   log("video id--${widget.data[widget.id].videoId}");
  //   log('---widget.data[widget.id].videoVisits-------${widget.data[widget.id].videoVisits}');
  // }
  //
  // likeVideo({String? id}) async {
  //   await _videoLikeViewModel.videoLikeViewModel(id: id);
  //
  //   VideoLikeResponseModel responseLike = _videoLikeViewModel.apiResponse.data;
  //   setState(() {
  //     widget.data[widget.id].videoLike =
  //         responseLike.data!.totalLikes.toString();
  //   });
  //   print(
  //       '---widget.data[widget.id].videoLike-------${widget.data[widget.id].videoLike}');
  // }
  //
  // dislikeVideo({String? id}) async {
  //   await _videoDislikeViewModel.videoDislikeViewModel(id: id);
  //   VideoDislikeResponseModel responseDislike =
  //       _videoDislikeViewModel.apiResponse.data;
  //   setState(() {
  //     widget.data[widget.id].videoDislike =
  //         responseDislike.data!.totalDislikes.toString();
  //   });
  //   print(
  //       '---widget.data[widget.id].videoDisLike-------${widget.data[widget.id].videoDislike}');
  // }

  @override
  Widget build(BuildContext context) {
    // AllVideoResponseModel response = _videoByIdViewModel.apiResponse.data;

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
        title: Text('Video Library', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: Get.height * .02),
        //     child: IconButton(
        //       onPressed: () {
        //         _launchURL();
        //       },
        //       icon: Image.asset(AppIcons.youtube),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: Get.height / 2.75,
              width: Get.width,
              child: '${widget.data[widget.id].videoUrl}'
                      .contains('www.youtube.com')
                  ? Center(
                      child: _youTubePlayerController != null ||
                              _youTubePlayerController != ''
                          ? YoutubePlayer(
                              controller: _youTubePlayerController,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: ColorUtils.kTint,
                              aspectRatio: 16 / 9,
                              progressColors: ProgressBarColors(
                                  handleColor: ColorUtils.kRed,
                                  playedColor: ColorUtils.kRed,
                                  backgroundColor: ColorUtils.kGray,
                                  bufferedColor: ColorUtils.kLightGray),
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              color: ColorUtils.kTint,
                            )),
                    )
                  : Center(
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
                  SizedBox(height: Get.height * 0.008),
                  SizedBox(height: Get.height * 0.02),
                  htmlToText(data: widget.data[widget.id].videoDescription),
                  SizedBox(height: Get.height * 0.03),
                  Text(
                    'RELATED VIDEOS',
                    style: FontTextStyle.kWhite16BoldRoboto,
                  ),
                  Divider(
                    color: ColorUtils.kTint,
                    height: Get.height * .03,
                    thickness: 1.5,
                  ),
                  SizedBox(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 7,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () {
                              print("button pressed ");
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: Get.height * .02),
                                    height: Get.height * 0.1,
                                    width: Get.height * 0.1,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorUtils.kTint, width: 1),
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                            image: AssetImage(AppImages.logo),
                                            scale: 2.5)),
                                  ),
                                ),
                                SizedBox(width: Get.height * .03),
                                Expanded(
                                  flex: 4,
                                  child: SizedBox(
                                    height: Get.height * 0.1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Best Chiro Treatment for',
                                          style:
                                              FontTextStyle.kWhite17BoldRoboto,
                                        ),
                                        Text(
                                          AppText.perfectDayText
                                                  .substring(0, 35) +
                                              ('...'),
                                          maxLines: 1,
                                          style: FontTextStyle
                                              .kLightGray16W300Roboto,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
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
