import 'dart:developer' as d;

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import 'package:social_share/social_share.dart';
import 'package:tcm/model/request_model/forum_request_model/dislike_forum_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/like_forum_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/search_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forums_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/forum/add_forum_screen.dart';
import 'package:tcm/screen/forum/comment_screen.dart';
import 'package:tcm/screen/home_screen.dart';

import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/images.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../api_services/api_response.dart';
import '../../utils/font_styles.dart';
import '../../viewModel/forum_viewModel/forum_viewmodel.dart';
import 'forum_video_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

enum Menu { HotPosts, PopularPosts, All }
enum Options { report, delete }

class _ForumScreenState extends State<ForumScreen> {
  String _selectedOptions = '';
  ForumViewModel forumViewModel = Get.put(ForumViewModel());
  GetAllForumsResponseModel response = GetAllForumsResponseModel();
  CarouselController carouselController = CarouselController();
  int _current = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forumViewModel.selectedMenu = 'All Posts'.obs;
    SearchForumRequestModel model = SearchForumRequestModel();
    model.title = '';
    model.userId = PreferenceManager.getUId();
    forumViewModel.searchForumViewModel(model);
    // forumViewModel.getAllForumsViewModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Forums', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
            child: Container(
              decoration: BoxDecoration(
                  color: ColorUtils.kSaperatedGray,
                  borderRadius: BorderRadius.circular(10)),
              height: Get.height * 0.05,
              width: Get.width,
              child: TextField(
                  style: FontTextStyle.kWhite16W300Roboto,
                  onTap: () async {
                    forumViewModel.selectedMenu = 'All Posts'.obs;
                    SearchForumRequestModel model1 = SearchForumRequestModel();
                    model1.title = '';
                    model1.userId = PreferenceManager.getUId();

                    await forumViewModel.searchForumViewModel(model1);
                  },
                  onChanged: (value) async {
                    forumViewModel.setAllPost(value);
                    SearchForumRequestModel model = SearchForumRequestModel();
                    model.title = value;
                    model.userId = PreferenceManager.getUId();

                    await forumViewModel.searchForumViewModel(model);
                  },
                  decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: FontTextStyle.kLightGray16W300Roboto,
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: ColorUtils.kTint,
                        size: Get.height * 0.03,
                      ),
                      suffixIcon: PopupMenuButton<Menu>(
                          color: ColorUtils.kBlack,
                          icon: Image.asset(
                            AppImages.filter,
                            fit: BoxFit.contain,
                            color: ColorUtils.kTint,
                            height: Get.height * 0.03,
                            width: Get.height * 0.03,
                          ),
                          // Callback that sets the selected popup menu item.
                          onSelected: (Menu item) async {
                            if (item.name == 'HotPosts') {
                              forumViewModel.selectedMenu = 'Hot Posts'.obs;
                              // forumViewModel.setSelectedMenu('Hot Posts');

                              await forumViewModel.getAllForumsViewModel(
                                  filter: 'hot');
                            } else if (item.name == 'PopularPosts') {
                              forumViewModel.selectedMenu = 'Popular Posts'.obs;
                              // forumViewModel.setSelectedMenu('Popular Posts');

                              await forumViewModel.getAllForumsViewModel(
                                  filter: 'popular');
                            } else if (item.name == 'All') {
                              forumViewModel.selectedMenu = 'All Posts'.obs;
                              // forumViewModel.setSelectedMenu('All Posts');

                              SearchForumRequestModel model =
                                  SearchForumRequestModel();
                              model.title = '';
                              model.userId = PreferenceManager.getUId();

                              await forumViewModel.searchForumViewModel(model);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<Menu>>[
                                PopupMenuItem<Menu>(
                                  value: Menu.HotPosts,
                                  child: Text(
                                    'Hot Posts',
                                    style: FontTextStyle.kWhite16W300Roboto,
                                  ),
                                ),
                                PopupMenuItem<Menu>(
                                  value: Menu.PopularPosts,
                                  child: Text(
                                    'Popular Posts',
                                    style: FontTextStyle.kWhite16W300Roboto,
                                  ),
                                ),
                                PopupMenuItem<Menu>(
                                  value: Menu.All,
                                  child: Text(
                                    'All Posts',
                                    style: FontTextStyle.kWhite16W300Roboto,
                                  ),
                                ),
                              ]))),
            ),
          ),
          Divider(
            color: ColorUtils.kTint,
            height: Get.height * .03,
            thickness: 1,
          ),
          Obx(() {
            return Padding(
              padding: EdgeInsets.only(left: Get.height * 0.02),
              child: Text(
                '${forumViewModel.selectedMenu} : ',
                style: FontTextStyle.kWhite17W400Roboto,
              ),
            );
          }),
          GetBuilder<ForumViewModel>(
            builder: (controller) {
              // print('_selectedMenu  ${controller.selectedMenu}');
              if (forumViewModel.selectedMenu.value == 'All Posts') {
                if (controller.searchApiResponse.status == Status.LOADING) {
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(
                      color: ColorUtils.kTint,
                    ),
                  ));
                }
                if (controller.searchApiResponse.status == Status.ERROR) {
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Server Error',
                      style: FontTextStyle.kTine16W400Roboto,
                    ),
                  ));
                }

                response = controller.searchApiResponse.data;
                controller.setLikeDisLike(response.data!);
              } else {
                if (controller.getAllForumsApiResponse.status ==
                    Status.LOADING) {
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(
                      color: ColorUtils.kTint,
                    ),
                  ));
                }
                if (controller.getAllForumsApiResponse.status == Status.ERROR) {
                  return Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Server Error',
                      style: FontTextStyle.kTine16W400Roboto,
                    ),
                  ));
                }

                response = controller.getAllForumsApiResponse.data;
                controller.setLikeDisLike(response.data!);
              }

              if (response.data!.isEmpty) {
                return Center(
                    child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'No data found',
                    style: FontTextStyle.kTine16W400Roboto,
                  ),
                ));
              }
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.height * 0.02,
                      vertical: Get.height * 0.02),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: response.data!.length,
                    itemBuilder: (context, index) {
                      return response.data![index].postId == null
                          ? SizedBox()
                          : Column(
                              children: [
                                Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: ColorUtils.kSaperatedGray
                                          .withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.height * 0.013,
                                        vertical: Get.height * 0.013),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        boxHeader(
                                            response: response,
                                            index: index,
                                            controller: controller),
                                        SizedBox(height: Get.height * 0.01),
                                        boxBody(
                                            response: response, index: index),
                                        SizedBox(height: Get.height * 0.02),
                                        boxFooter(
                                            response: response,
                                            index: index,
                                            controller: controller),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.02),
                              ],
                            );
                    },
                  ),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          forumViewModel.selectedMenu = 'All Posts'.obs;

          Get.to(AddForumScreen());
        },
        child: CircleAvatar(
          backgroundColor: ColorUtils.kTint,
          radius: Get.height * 0.03,
          child: Icon(
            Icons.add,
            color: ColorUtils.kBlack,
            size: Get.height * 0.04,
          ),
        ),
      ),
    );
  }

  Widget boxBody(
      {GetAllForumsResponseModel? response,
      int? index,
      ForumViewModel? forumViewModel}) {
    return GestureDetector(
      onTap: () {
        // Get.to(ForumDetailScreen(
        //   response: response!.data![index!],
        //   forumViewModel: forumViewModel,
        //   index: index,
        // ));
      },
      child: Container(
        color: Colors.transparent,
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              direction: Axis.horizontal,
              children: List.generate(response!.data![index!].tagTitle!.length,
                  (index1) {
                return Text(
                  '#${response.data![index].tagTitle![index1]} ',
                  overflow: TextOverflow.ellipsis,
                  style: FontTextStyle.kTine17BoldRoboto.copyWith(
                    fontSize: Get.height * 0.0185,
                  ),
                );
              }),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            response.data![index].postImage == null
                ? SizedBox()
                : response.data![index].postImage!.length == 1
                    ? response.data![index].postImage![0].isVideoFileName
                        ? Center(
                            child: Container(
                              height: Get.height * 0.23,
                              width: Get.width,
                              child: ForumVideoScreen(
                                  video: response.data![index].postImage![0]),
                            ),
                          )
                        : Center(
                            child: Container(
                              width: Get.width,
                              height: Get.height * 0.23,
                              child: Image.network(
                                response.data![index].postImage![0],
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                    : SizedBox(
                        height: Get.height * 0.25,
                        child: Column(
                          children: [
                            Container(
                              height: Get.height * 0.23,
                              child: CarouselSlider.builder(
                                carouselController: carouselController,
                                itemCount:
                                    response.data![index].postImage!.length,
                                itemBuilder: (BuildContext context,
                                    int itemIndex, int pageViewIndex) {
                                  return Container(
                                    width: Get.width,
                                    child: response
                                            .data![index]
                                            .postImage![itemIndex]
                                            .isVideoFileName
                                        ? ForumVideoScreen(
                                            isPlay: _current == itemIndex
                                                ? true
                                                : false,
                                            video: response.data![index]
                                                .postImage![itemIndex])
                                        : Image.network(
                                            response.data![index]
                                                .postImage![itemIndex],
                                            fit: BoxFit.cover,
                                          ),
                                  );
                                },
                                options: CarouselOptions(
                                  autoPlay: false,
                                  enableInfiniteScroll: false,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.99,
                                  aspectRatio: 2.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                  initialPage: 0,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  response.data![index].postImage!.length,
                                  (index) => Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: CircleAvatar(
                                          radius: Get.height * 0.006,
                                          backgroundColor: _current == index
                                              ? ColorUtils.kTint
                                              : ColorUtils.kTint
                                                  .withOpacity(0.4),
                                        ),
                                      )),
                            )
                          ],
                        ),
                      ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Text(
              '${response.data![index].postTitle!.replaceFirst(response.data![index].postTitle![0], response.data![index].postTitle![0].toUpperCase())}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: FontTextStyle.kWhite17W400Roboto.copyWith(
                fontSize: Get.height * 0.0185,
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            ExpandableText(
              '${response.data![index].postDescription}',
              style: FontTextStyle.kLightGray16W300Roboto,
              expandText: 'Show more',
              collapseText: 'Show less',
              maxLines: 5,
              animation: true,
              animationCurve: Curves.bounceIn,
              linkColor: ColorUtils.kTint,
            ),
          ],
        ),
      ),
    );
  }

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  Future<void> initializeVideoPlayer(String url) async {
    videoPlayerController = VideoPlayerController.network(url);
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

  Widget boxHeader(
      {GetAllForumsResponseModel? response,
      int? index,
      ForumViewModel? controller}) {
    return Stack(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.dialog(Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: Get.height * 0.3,
                          width: Get.height * 0.3,
                          decoration: BoxDecoration(
                              color: ColorUtils.kBlack,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: response!.data![index!].profilePic ==
                                          ''
                                      ? NetworkImage(
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                        )
                                      : NetworkImage(
                                          response.data![index].profilePic!),
                                  fit: BoxFit.cover))),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          '${response.data![index].username} ',
                          style: FontTextStyle.kWhite20BoldRoboto,
                        ),
                      ),
                    ],
                  ),
                ));
              },
              child: Container(
                height: Get.height * 0.06,
                width: Get.height * 0.06,
                decoration: BoxDecoration(
                    color: ColorUtils.kBlack,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorUtils.kTint),
                    image: DecorationImage(
                        image: response!.data![index!].profilePic == ''
                            ? NetworkImage(
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                              )
                            : NetworkImage(response.data![index].profilePic!),
                        fit: BoxFit.cover)),
              ),
            ),
            SizedBox(
              width: Get.width * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${response.data![index].username} ',
                  style: FontTextStyle.kWhite17W400Roboto,
                ),
                SizedBox(
                  height: Get.height * 0.005,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: Get.height * 0.007,
                      color: ColorUtils.kLightGray,
                    ),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    response.data![index].postDate!.isEmpty
                        ? SizedBox()
                        : Text(
                            '${response.data![index].postDate} ',
                            style: FontTextStyle.kLightGray16W300Roboto
                                .copyWith(fontSize: Get.height * 0.018),
                          ),
                  ],
                ),
              ],
            )
          ],
        ),
        Positioned(
          top: -10,
          right: -10,
          child: PopupMenuButton<Options>(
              color: ColorUtils.kBlack,
              icon: Icon(
                Icons.more_vert,
                color: ColorUtils.kTint,
                size: Get.height * 0.025,
              ),
              // Callback that sets the selected popup menu item.
              onSelected: (Options item) async {
                setState(() {
                  _selectedOptions = item.name;
                });
                if (_selectedOptions == 'report') {
                  await forumViewModel
                      .reportForumViewModel(response.data![index].postId!);
                } else {
                  await forumViewModel
                      .deleteForumViewModel(response.data![index].postId!)
                      .then((value) async {
                    Get.showSnackbar(GetSnackBar(
                      duration: Duration(seconds: 2),
                      messageText: Text(
                        'Post deleted successfully....',
                        style: FontTextStyle.kTine17BoldRoboto,
                      ),
                    ));
                    SearchForumRequestModel model = SearchForumRequestModel();
                    model.title = controller!.allPost;
                    model.userId = PreferenceManager.getUId();

                    if (forumViewModel.selectedMenu.value == 'All Posts') {
                      await forumViewModel.searchForumViewModel(model);
                    } else if (forumViewModel.selectedMenu.value ==
                        'Hot Posts') {
                      await forumViewModel.getAllForumsViewModel(filter: 'hot');
                    } else if (forumViewModel.selectedMenu.value ==
                        'Popular Posts') {
                      await forumViewModel.getAllForumsViewModel(
                          filter: 'popular');
                    }
                  });
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
                    PopupMenuItem<Options>(
                      value: Options.report,
                      child: Text(
                        'Report',
                        style: FontTextStyle.kWhite16W300Roboto,
                      ),
                    ),
                    response.data![index].userId == PreferenceManager.getUId()
                        ? PopupMenuItem<Options>(
                            value: Options.delete,
                            child: Text(
                              'Delete',
                              style: FontTextStyle.kWhite16W300Roboto,
                            ),
                          )
                        : PopupMenuItem(
                            height: 0,
                            child: SizedBox(),
                          ),
                  ]),
        )
      ],
    );
  }

  bool isLike = false;
  bool isUnLike = false;
  Padding boxFooter(
      {GetAllForumsResponseModel? response,
      int? index,
      ForumViewModel? controller}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  if (controller!.likeDisLike[index!].userLiked == 0) {
                    controller.likeDisLike[index].userLiked = 1;
                    controller.likeDisLike[index].userDisliked = 0;
                    controller.likeDisLike[index].totalLikes =
                        controller.likeDisLike[index].totalLikes! + 1;
                    LikeForumRequestModel model = LikeForumRequestModel();
                    model.postId = response!.data![index].postId;
                    model.userId = PreferenceManager.getUId();
                    model.like = '1';
                    model.disLike = '0';
                    await controller.likeForumViewModel(model);
                    // if (controller.likeForumApiResponse.status ==
                    //     Status.COMPLETE) {
                    //   SearchForumRequestModel model = SearchForumRequestModel();
                    //   print('controller.allPost ${controller.allPost}');
                    //   model.title = controller.allPost;
                    //   model.userId = PreferenceManager.getUId();
                    //   //
                    //   // await controller.searchForumViewModel(model);
                    //   // if (controller.addForumApiResponse.status ==
                    //   //     Status.COMPLETE) {
                    //   //   GetAllForumsResponseModel response =
                    //   //       controller.searchApiResponse.data;
                    //   //   controller.setLikeDisLike(response.data!);
                    //   // }
                    // } else {
                    //   print('please try again');
                    // }
                  } else if (controller.likeDisLike[index].userLiked == 1) {
                    controller.likeDisLike[index].userLiked = 0;
                    controller.likeDisLike[index].totalLikes =
                        controller.likeDisLike[index].totalLikes! - 1;
                    LikeForumRequestModel model = LikeForumRequestModel();
                    model.postId = response!.data![index].postId;
                    model.userId = PreferenceManager.getUId();
                    model.like = '0';
                    model.disLike = '0';
                    await controller.likeForumViewModel(model);
                    // if (controller.likeForumApiResponse.status ==
                    //     Status.COMPLETE) {
                    //   SearchForumRequestModel model = SearchForumRequestModel();
                    //   print('controller.allPost ${controller.allPost}');
                    //   model.title = controller.allPost;
                    //   model.userId = PreferenceManager.getUId();
                    //
                    //   // await controller.searchForumViewModel(model);
                    //   // if (controller.addForumApiResponse.status ==
                    //   //     Status.COMPLETE) {
                    //   //   GetAllForumsResponseModel response =
                    //   //       controller.searchApiResponse.data;
                    //   //   controller.setLikeDisLike(response.data!);
                    //   // }
                    // } else {
                    //   print('please try again');
                    // }
                  }
                },
                child: controller!.likeDisLike[index!].userLiked == 0
                    ? Image.asset(
                        AppImages.arrowUpBorder,
                        color: ColorUtils.kTint,
                        height: Get.height * 0.022,
                        width: Get.height * 0.022,
                      )
                    : Image.asset(
                        AppImages.arrowUp,
                        color: ColorUtils.kTint,
                        height: Get.height * 0.022,
                        width: Get.height * 0.022,
                      ),
              ),
              SizedBox(
                width: Get.width * 0.02,
              ),
              controller.likeDisLike[index].totalLikes.toString().length <= 3
                  ? Text(
                      '${controller.likeDisLike[index].totalLikes}',
                      style: FontTextStyle.kWhite17W400Roboto.copyWith(
                        fontSize: Get.height * 0.0185,
                      ),
                    )
                  : Text(
                      '${NumberFormat.compactCurrency(
                        decimalDigits: 2,
                        symbol:
                            '', // if you want to add currency symbol then pass that in this else leave it empty.
                      ).format(controller.likeDisLike[index].totalLikes)}',
                      style: FontTextStyle.kWhite17W400Roboto.copyWith(
                        fontSize: Get.height * 0.0185,
                      ),
                    ),
              SizedBox(
                width: Get.width * 0.02,
              ),
              GestureDetector(
                onTap: () async {
                  if (response!.data![index].userDisliked == 0) {
                    if (controller.likeDisLike[index].userLiked == 0) {
                      controller.likeDisLike[index].userDisliked = 1;
                      DisLikeForumRequestModel model =
                          DisLikeForumRequestModel();
                      model.postId = response.data![index].postId;
                      model.userId = PreferenceManager.getUId();
                      model.like = '0';
                      model.disLike = '1';
                      await controller.disLikeForumViewModel(model);
                    } else {
                      controller.likeDisLike[index].userDisliked = 1;
                      controller.likeDisLike[index].totalLikes =
                          controller.likeDisLike[index].totalLikes! - 1;
                      controller.likeDisLike[index].userLiked = 0;
                      DisLikeForumRequestModel model =
                          DisLikeForumRequestModel();
                      model.postId = response.data![index].postId;
                      model.userId = PreferenceManager.getUId();
                      model.like = '0';
                      model.disLike = '1';
                      await controller.disLikeForumViewModel(model);
                    }
                  } else if (response.data![index].userDisliked == 1) {
                    controller.likeDisLike[index].userDisliked = 0;

                    DisLikeForumRequestModel model = DisLikeForumRequestModel();
                    model.postId = response.data![index].postId;
                    model.userId = PreferenceManager.getUId();
                    model.like = '0';
                    model.disLike = '0';
                    await controller.disLikeForumViewModel(model);
                  } else {}
                },
                child: response!.data![index].userDisliked == 0
                    ? Image.asset(
                        AppImages.arrowDownBorder,
                        color: ColorUtils.kTint,
                        height: Get.height * 0.022,
                        width: Get.height * 0.022,
                      )
                    : Image.asset(
                        AppImages.arrowDown,
                        color: ColorUtils.kTint,
                        height: Get.height * 0.022,
                        width: Get.height * 0.022,
                      ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              Get.to(CommentScreen(
                postId: response.data![index].postId,
              ));
            },
            child: Row(
              children: [
                Image.asset(
                  AppImages.comment,
                  color: ColorUtils.kTint,
                  height: Get.height * 0.022,
                  width: Get.height * 0.022,
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                controller.likeDisLike[index].totalComments.toString().length <=
                        3
                    ? Text(
                        '${controller.likeDisLike[index].totalComments}',
                        style: FontTextStyle.kWhite17W400Roboto.copyWith(
                          fontSize: Get.height * 0.0185,
                        ),
                      )
                    : Text(
                        '${NumberFormat.compactCurrency(
                          decimalDigits: 2,
                          symbol:
                              '', // if you want to add currency symbol then pass that in this else leave it empty.
                        ).format(controller.likeDisLike[index].totalComments)}',
                        style: FontTextStyle.kWhite17W400Roboto.copyWith(
                          fontSize: Get.height * 0.0185,
                        ),
                      ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              Share.share(response.data![index].postTitle!,
                  subject: response.data![index].postDescription!);
            },
            child: Row(
              children: [
                Image.asset(
                  AppImages.share,
                  color: ColorUtils.kTint,
                  height: Get.height * 0.022,
                  width: Get.height * 0.022,
                ),
                SizedBox(
                  width: Get.width * 0.02,
                ),
                Text(
                  'Share',
                  style: FontTextStyle.kWhite17W400Roboto.copyWith(
                    fontSize: Get.height * 0.0185,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
