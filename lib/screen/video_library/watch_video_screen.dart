import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/vimeo_video_player/vimeo_video_player.dart';
import 'package:tcm/model/response_model/video_library_response_model/all_video_res_model.dart';
import 'package:tcm/model/response_model/video_library_response_model/recent_video_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/video_library/related_video_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/video_library_viewModel/recent_video_viewModel.dart';
import 'package:tcm/custom_packages/vimeo_video_player/vimeo_controller.dart';
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
  RecentVideoViewModel _recentVideoViewModel = Get.put(RecentVideoViewModel());
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  // Future<void> _initializeVideoPlayerFuture;
  // VideoByIdViewModel _videoByIdViewModel = Get.put(VideoByIdViewModel());
  // AllVideoViewModel _allVideoViewModel = Get.put(AllVideoViewModel());
  // VideoViewsViewModel _videoViewsViewModel = Get.put(VideoViewsViewModel());
  // VideoLikeViewModel _videoLikeViewModel = Get.put(VideoLikeViewModel());
  // VideoDislikeViewModel _videoDislikeViewModel =
  //     Get.put(VideoDislikeViewModel());

  VimeoController _vimeoController = Get.put(VimeoController());
  @override
  void initState() {
    super.initState();
    _vimeoController.res = widget.data;
    _vimeoController.index = widget.id;

    _connectivityCheckViewModel.startMonitoring();

    print(
        "-=-=-=-=-=-=-=-=-=- ${widget.data[widget.id].videoId} ----------- ${widget.data[widget.id].categoryId}");

    _recentVideoViewModel.getRecentVideoDetails(
        videoId: widget.data[widget.id].videoId,
        categoryId: widget.data[widget.id].categoryId);
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

  @override
  Widget build(BuildContext context) {
    // AllVideoResponseModel response = _videoByIdViewModel.apiResponse.data;
    return GetBuilder<ConnectivityCheckViewModel>(
      builder: (control) {
        return control.isOnline
            ? '${widget.data[widget.id].videoUrl}'.contains('www.youtube.com')
                ? YoutubePlayerBuilder(
                    onExitFullScreen: () {
                      // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                      // SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                    },
                    player: YoutubePlayer(
                      controller: _youTubePlayerController,
                      showVideoProgressIndicator: true,
                      width: Get.width,
                      progressIndicatorColor: ColorUtils.kTint,
                      // aspectRatio: 16 / 9,
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
                                        style:
                                            FontTextStyle.kWhite17BoldRoboto),
                                    SizedBox(height: Get.height * .008),
                                    htmlToText(
                                        data: widget
                                            .data[widget.id].videoDescription),
                                    SizedBox(height: Get.height * .02),
                                    Text(
                                      'RELATED VIDEOS',
                                      style: FontTextStyle.kWhite16BoldRoboto,
                                    ),
                                    Divider(
                                      color: ColorUtils.kTint,
                                      height: Get.height * .03,
                                      thickness: 1.5,
                                    ),
                                    GetBuilder<RecentVideoViewModel>(
                                        builder: (controller) {
                                      if (controller.apiResponse.status ==
                                          Status.LOADING) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                          color: ColorUtils.kTint,
                                        ));
                                      }
                                      if (controller.apiResponse.status ==
                                          Status.ERROR) {
                                        return Center(
                                          child: Text(
                                            'Server error',
                                            style:
                                                FontTextStyle.kTine16W400Roboto,
                                          ),
                                        );
                                      }
                                      RecentVideoResponseModel response =
                                          controller.apiResponse.data;

                                      if (response.data!.isEmpty) {
                                        print(
                                            'response.data!.isEmpty>>>>>> ${response.data!.isEmpty}');
                                        return Center(
                                          child: Text(
                                            'No related data',
                                            style:
                                                FontTextStyle.kTine16W400Roboto,
                                          ),
                                        );
                                      }
                                      if (controller.apiResponse.status ==
                                          Status.COMPLETE) {
                                        return SizedBox(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: response.data!.length,
                                              itemBuilder: (_, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    _youTubePlayerController
                                                        .pause();

                                                    Get.to(RelatedVideoScreen(
                                                      data: response.data!,
                                                      id: index,
                                                    ));

                                                    print("button pressed ");
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          /*margin: EdgeInsets.only(
                                                              top: Get.height *
                                                                  .02),*/
                                                          height:
                                                              Get.height * 0.1,
                                                          width:
                                                              Get.height * 0.1,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      ColorUtils
                                                                          .kTint,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              image: DecorationImage(
                                                                  image: NetworkImage(response
                                                                      .data![
                                                                          index]
                                                                      .videoThumbnail!),
                                                                  scale: 2.5)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              Get.height * .03),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${response.data![index].videoTitle}',
                                                              style: FontTextStyle
                                                                  .kWhite17BoldRoboto,
                                                            ),
                                                            htmlToTextGreyVidDesc(
                                                                data: '${response.data![index].videoDescription!}'
                                                                            .length >
                                                                        30
                                                                    ? response
                                                                            .data![
                                                                                index]
                                                                            .videoDescription!
                                                                            .substring(0,
                                                                                30) +
                                                                        ('...')
                                                                    : response
                                                                        .data![
                                                                            index]
                                                                        .videoDescription!),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        );
                                      }
                                      return SizedBox();
                                    }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : '${widget.data[widget.id].videoUrl}'
                        .contains('https://vimeo.com/')
                    ? Scaffold(
                        backgroundColor: ColorUtils.kBlack,
                        appBar: AppBar(
                          elevation: 0,
                          leading: IconButton(
                              onPressed: () {
                                _vimeoController.videoPause();
                                Get.back();
                                // Get.off(VideoLibraryScreen());
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_sharp,
                                color: ColorUtils.kTint,
                              )),
                          backgroundColor: ColorUtils.kBlack,
                          title: Text('Video Library',
                              style: FontTextStyle.kWhite16BoldRoboto),
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
                                child: Center(
                                  child: VimeoVideoPlayer(
                                    url: widget.data[widget.id].videoUrl!,
                                    deviceOrientation:
                                        DeviceOrientation.portraitUp,
                                    systemUiOverlay: const [
                                      SystemUiOverlay.top,
                                      SystemUiOverlay.bottom,
                                    ],
                                  ),
                                ),
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
                                        style:
                                            FontTextStyle.kWhite17BoldRoboto),
                                    SizedBox(height: Get.height * .008),
                                    htmlToText(
                                        data: widget
                                            .data[widget.id].videoDescription),
                                    SizedBox(height: Get.height * .02),
                                    Text(
                                      'RELATED VIDEOS',
                                      style: FontTextStyle.kWhite16BoldRoboto,
                                    ),
                                    Divider(
                                      color: ColorUtils.kTint,
                                      height: Get.height * .03,
                                      thickness: 1.5,
                                    ),
                                    GetBuilder<RecentVideoViewModel>(
                                        builder: (controller) {
                                      if (controller.apiResponse.status ==
                                          Status.LOADING) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                          color: ColorUtils.kTint,
                                        ));
                                      }
                                      RecentVideoResponseModel response =
                                          controller.apiResponse.data;
                                      if (response.data!.isEmpty) {
                                        print(
                                            'response.data!.isEmpty>>>>>> ${response.data!.isEmpty}');
                                        return Center(
                                          child: Text(
                                            'No related data',
                                            style:
                                                FontTextStyle.kTine16W400Roboto,
                                          ),
                                        );
                                      }
                                      if (controller.apiResponse.status ==
                                          Status.COMPLETE) {
                                        return SizedBox(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: response.data!.length,
                                              itemBuilder: (_, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        'data :  ${response.data!}');
                                                    print('id :  ${index}');

                                                    ///852
                                                    _vimeoController
                                                        .videoPause();
                                                    // _videoPlayerController
                                                    //     .pause();

                                                    Get.to(RelatedVideoScreen(
                                                      data: response.data!,
                                                      id: index,
                                                    ));

                                                    print("button pressed ");
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          /*   margin: EdgeInsets.only(
                                                              top: Get.height *
                                                                  .02),*/
                                                          height:
                                                              Get.height * 0.1,
                                                          width:
                                                              Get.height * 0.1,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      ColorUtils
                                                                          .kTint,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              image: DecorationImage(
                                                                  image: NetworkImage(response
                                                                      .data![
                                                                          index]
                                                                      .videoThumbnail!),
                                                                  scale: 2.5)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              Get.height * .03),
                                                      Expanded(
                                                        flex: 4,
                                                        child: SizedBox(
                                                          height:
                                                              Get.height * .1,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${response.data![index].videoTitle}'
                                                                            .length >
                                                                        30
                                                                    ? '${response.data![index].videoTitle}'.substring(
                                                                            0,
                                                                            28) +
                                                                        "..."
                                                                    : '${response.data![index].videoTitle}',
                                                                style: FontTextStyle
                                                                    .kWhite17BoldRoboto,
                                                              ),
                                                              htmlToTextGrey(
                                                                  data: '${response.data![index].videoDescription!}'
                                                                              .length >
                                                                          25
                                                                      ? response.data![index].videoDescription!.substring(
                                                                              0,
                                                                              22) +
                                                                          ('...')
                                                                      : response
                                                                          .data![
                                                                              index]
                                                                          .videoDescription!),

                                                              // maxLines: 1,
                                                              // style: FontTextStyle
                                                              //     .kLightGray16W300Roboto,
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        );
                                      }
                                      return SizedBox();
                                    }),
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
                                child: Center(
                                  child: _chewieController != null &&
                                          _chewieController!
                                              .videoPlayerController
                                              .value
                                              .isInitialized
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
                                        style:
                                            FontTextStyle.kWhite17BoldRoboto),
                                    SizedBox(height: Get.height * .008),
                                    htmlToText(
                                        data: widget
                                            .data[widget.id].videoDescription),
                                    SizedBox(height: Get.height * .02),
                                    Text(
                                      'RELATED VIDEOS',
                                      style: FontTextStyle.kWhite16BoldRoboto,
                                    ),
                                    Divider(
                                      color: ColorUtils.kTint,
                                      height: Get.height * .03,
                                      thickness: 1.5,
                                    ),
                                    GetBuilder<RecentVideoViewModel>(
                                        builder: (controller) {
                                      if (controller.apiResponse.status ==
                                          Status.LOADING) {
                                        return Center(
                                            child: CircularProgressIndicator(
                                          color: ColorUtils.kTint,
                                        ));
                                      }
                                      RecentVideoResponseModel response =
                                          controller.apiResponse.data;
                                      if (response.data!.isEmpty) {
                                        print(
                                            'response.data!.isEmpty>>>>>> ${response.data!.isEmpty}');
                                        return Center(
                                          child: Text(
                                            'No related data',
                                            style:
                                                FontTextStyle.kTine16W400Roboto,
                                          ),
                                        );
                                      }
                                      if (controller.apiResponse.status ==
                                          Status.COMPLETE) {
                                        return SizedBox(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: response.data!.length,
                                              itemBuilder: (_, index) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    _chewieController!.pause();
                                                    _videoPlayerController
                                                        .pause();
                                                    Get.to(RelatedVideoScreen(
                                                      data: response.data!,
                                                      id: index,
                                                    ));

                                                    print("button pressed ");
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          /*  margin: EdgeInsets.only(
                                                              top: Get.height *
                                                                  .02),*/
                                                          height:
                                                              Get.height * 0.1,
                                                          width:
                                                              Get.height * 0.1,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      ColorUtils
                                                                          .kTint,
                                                                  width: 1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              image: DecorationImage(
                                                                  image: NetworkImage(response
                                                                      .data![
                                                                          index]
                                                                      .videoThumbnail!),
                                                                  scale: 2.5)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              Get.height * .03),
                                                      Expanded(
                                                        flex: 4,
                                                        child: SizedBox(
                                                          height:
                                                              Get.height * .1,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                '${response.data![index].videoTitle}',
                                                                style: FontTextStyle
                                                                    .kWhite17BoldRoboto,
                                                              ),
                                                              htmlToTextGrey(
                                                                data:
                                                                    '${response.data![index].videoDescription}',

                                                                // maxLines: 1,
                                                                // style: FontTextStyle
                                                                //     .kLightGray16W300Roboto,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        );
                                      }
                                      return SizedBox();
                                    }),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
            : ConnectionCheckScreen();
      },
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
