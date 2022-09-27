import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/all_categories_response_model.dart';
import 'package:tcm/model/response_model/video_library_response_model/all_video_res_model.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/video_library/video_single_cat_screen.dart';
import 'package:tcm/screen/video_library/watch_video_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/all_categories_viewModel.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/video_library_viewModel/all_video_viewModel.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoLibraryScreen extends StatefulWidget {
  @override
  State<VideoLibraryScreen> createState() => _VideoLibraryScreenState();
}

class _VideoLibraryScreenState extends State<VideoLibraryScreen> {
  AllVideoViewModel _allVideoViewModel = Get.put(AllVideoViewModel());
  AllCategoriesViewModel _allCategoriesViewModel =
      Get.put(AllCategoriesViewModel());
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  File? thumbnail;
  String thumbnail1 = '';
  // final String _url = 'https://www.youtube.com/';

  void initState() {
    super.initState();

    _connectivityCheckViewModel.startMonitoring();
    // _allVideoViewModel.getVideoDetails();
    _allCategoriesViewModel.getCategoriesDetails();
    _allVideoViewModel.getVideoDetails();
  }

  void dispose() {
    super.dispose();
    // _allVideoViewModel.dispose();
  }

  List videoCatId = [];

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
                      // Get.offAll(HomeScreen());
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
                  child: Column(
                    children: [
                      SizedBox(
                        child: GetBuilder<AllCategoriesViewModel>(
                            builder: (categoriesController) {
                          return GetBuilder<AllVideoViewModel>(
                            builder: (videoController) {
                              if (categoriesController.apiResponse.status ==
                                  Status.LOADING) {
                                return SizedBox(
                                  height: Get.height,
                                  width: Get.width,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          color: ColorUtils.kTint)),
                                );
                              }
                              if (videoController.apiResponse.status ==
                                  Status.LOADING) {
                                return SizedBox(
                                  height: Get.height,
                                  width: Get.width,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          color: ColorUtils.kTint)),
                                );
                              }
                              if (categoriesController.apiResponse.status ==
                                  Status.ERROR) {
                                return Center(
                                    child: Text(
                                  'Server error',
                                  style: FontTextStyle.kTine17BoldRoboto,
                                ));
                              }
                              if (videoController.apiResponse.status ==
                                  Status.ERROR) {
                                return Center(
                                    child: Text(
                                  'Server error',
                                  style: FontTextStyle.kTine17BoldRoboto,
                                ));
                              }
                              if (categoriesController.apiResponse.status ==
                                  Status.COMPLETE) {
                                CategoriesResponseModel catResponse =
                                    categoriesController.apiResponse.data;

                                AllVideoResponseModel videoResponse =
                                    videoController.apiResponse.data;

                                for (int i = 0;
                                    i < videoResponse.data!.length;
                                    i++) {
                                  if (videoCatId.contains(
                                          videoResponse.data![i].categoryId) ==
                                      false) {
                                    videoCatId
                                        .add(videoResponse.data![i].categoryId);
                                  }
                                }

                                if (videoController.apiResponse.status ==
                                    Status.COMPLETE) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: catResponse.data!.length,
                                      itemBuilder: (_, index) {
                                        print(
                                            'catResponse.data!.length ${catResponse.data!.length}');
                                        return videoCatId.contains(catResponse
                                                .data![index].categoryId)
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top:
                                                                    Get.height *
                                                                        .03),
                                                        child: Text(
                                                          '${catResponse.data![index].categoryTitle}',
                                                          style: FontTextStyle
                                                              .kWhite16BoldRoboto,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top:
                                                                    Get.height *
                                                                        .03,
                                                                right: 5,
                                                                left: 5),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.to(
                                                                VideoSingleCatScreen(
                                                              videoCatID:
                                                                  '${catResponse.data![index].categoryId}',
                                                              videoCatName:
                                                                  '${catResponse.data![index].categoryTitle}',
                                                            ));
                                                          },
                                                          child: Text(
                                                            'More',
                                                            style: FontTextStyle
                                                                .kTine16W400Roboto,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: ColorUtils.kTint,
                                                    height: Get.height * .03,
                                                    thickness: 1.5,
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * 0.175,
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        shrinkWrap: true,
                                                        physics:
                                                            BouncingScrollPhysics(),
                                                        itemCount: videoResponse
                                                                    .data!
                                                                    .length >=
                                                                10
                                                            ? 10
                                                            : videoResponse
                                                                .data!.length,
                                                        itemBuilder:
                                                            (_, index1) {
                                                          log('videoResponse.data!.length  ${videoResponse.data![index1].videoUrl}');
                                                          print(
                                                              'CHECK------${catResponse.data![index].categoryId == videoResponse.data![index1].categoryId}');

                                                          return catResponse
                                                                      .data![
                                                                          index]
                                                                      .categoryId ==
                                                                  videoResponse
                                                                      .data![
                                                                          index1]
                                                                      .categoryId
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Get.to(
                                                                        WatchVideoScreen(
                                                                      id: index1,
                                                                      data: videoResponse
                                                                          .data!,
                                                                      // id: response.data![index1].videoId)
                                                                    ));
                                                                    print(
                                                                        "button pressed ");
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: Get.height *
                                                                            .01,
                                                                        right: Get.height *
                                                                            .02),
                                                                    height: Get
                                                                            .height *
                                                                        0.175,
                                                                    width: Get
                                                                            .height *
                                                                        0.125,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color: ColorUtils
                                                                              .kTint,
                                                                          width:
                                                                              1),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      child: Center(
                                                                          child: videoResponse.data![index1].videoThumbnail == null || videoResponse.data![index1].videoThumbnail == ''
                                                                              ? Padding(
                                                                                  padding: EdgeInsets.all(15.0),
                                                                                  child: Image.asset(AppImages.logo),
                                                                                )
                                                                              : Image.network(
                                                                                  videoResponse.data![index1].videoThumbnail!,
                                                                                  height: Get.height * 0.175,
                                                                                  width: Get.height * 0.125,
                                                                                  fit: BoxFit.cover,
                                                                                )),
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox();
                                                        }),
                                                  )
                                                ],
                                              )
                                            : SizedBox();
                                      });
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: ColorUtils.kTint,
                                  ),
                                );
                              }
                            },
                          );
                        }),
                      ),
                      SizedBox(height: Get.height * .025)
                    ],
                  ),
                ),
              ),
            )
          : ConnectionCheckScreen();
    });
  }

  String getYoutubeThumbnail(String videoUrl) {
    final Uri? uri = Uri.tryParse(videoUrl);

    return 'https://img.youtube.com/vi/${uri!.queryParameters['v']}/0.jpg';
  }

  Future<void>? data(String url) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight:
          100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    ).then((value) {
      setState(() {
        thumbnail = File(value!);
      });

      log('thumbnailthumbnailthumbnail ${thumbnail}');
    });
    log('fileNamefileNamefileName ${fileName}');
    // setState(() {

    // });
  }
}
