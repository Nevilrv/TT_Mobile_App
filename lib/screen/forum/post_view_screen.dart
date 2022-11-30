import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tcm/model/request_model/forum_request_model/like_forum_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/search_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forums_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/forum/forum_screen.dart';
import 'package:tcm/screen/forum/post_details_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'comment_screen.dart' as com;
import '../../viewModel/forum_viewModel/forum_viewmodel.dart';
import 'forum_video_screen.dart';

class PostViewAScreen extends StatefulWidget {
  final GetAllForumsResponseModel? response;
  final int index;
  final String postId;
  const PostViewAScreen(
      {Key? key,
      required this.response,
      required this.index,
      required this.postId})
      : super(key: key);
  @override
  State<PostViewAScreen> createState() => _PostViewAScreenState();
}

class _PostViewAScreenState extends State<PostViewAScreen> {
  String _selectedOptions = '';
  ForumViewModel forumViewModel = Get.put(ForumViewModel());
  int _current = 0;
  // ScrollController scrollController = ScrollController(
  //   initialScrollOffset: 10,
  //   keepScrollOffset: true,
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Divider(
              color: ColorUtils.kGray,
              thickness: 2,
            ),
          ),
          GetBuilder<ForumViewModel>(
            builder: (controller) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * 0.025),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (controller
                                    .likeDisLike[widget.index].userLiked ==
                                0) {
                              controller.likeDisLike[widget.index].userLiked =
                                  1;
                              controller
                                  .likeDisLike[widget.index].userDisliked = 0;
                              controller.likeDisLike[widget.index].totalLikes =
                                  controller.likeDisLike[widget.index]
                                          .totalLikes! +
                                      1;
                              LikeForumRequestModel model =
                                  LikeForumRequestModel();
                              model.postId = widget.postId;
                              model.userId = PreferenceManager.getUId();
                              model.like = '1';
                              model.disLike = '0';
                              await controller.likeForumViewModel(model);
                            } else if (controller
                                    .likeDisLike[widget.index].userLiked ==
                                1) {
                              controller.likeDisLike[widget.index].userLiked =
                                  0;
                              controller.likeDisLike[widget.index].totalLikes =
                                  controller.likeDisLike[widget.index]
                                          .totalLikes! -
                                      1;
                              LikeForumRequestModel model =
                                  LikeForumRequestModel();
                              model.postId = widget.postId;
                              model.userId = PreferenceManager.getUId();
                              model.like = '0';
                              model.disLike = '0';
                              await controller.likeForumViewModel(model);
                            }
                          },
                          child:
                              controller.likeDisLike[widget.index].userLiked ==
                                      0
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0, vertical: 2),
                                      child: Image.asset(
                                        AppImages.arrowUpBorder,
                                        color: ColorUtils.kTint,
                                        height: Get.height * 0.025,
                                        width: Get.height * 0.025,
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0, vertical: 2),
                                      child: Image.asset(
                                        AppImages.arrowUp,
                                        color: ColorUtils.kTint,
                                        height: Get.height * 0.025,
                                        width: Get.height * 0.025,
                                      ),
                                    ),
                        ),
                        SizedBox(
                          width: Get.width * 0.015,
                        ),
                        controller.likeDisLike[widget.index].totalLikes
                                    .toString()
                                    .length <=
                                3
                            ? Text(
                                '${controller.likeDisLike[widget.index].totalLikes}',
                                style:
                                    FontTextStyle.kWhite17W400Roboto.copyWith(
                                  fontSize: Get.height * 0.0185,
                                ),
                              )
                            : Text(
                                '${NumberFormat.compactCurrency(
                                  decimalDigits: 2,
                                  symbol:
                                      '', // if you want to add currency symbol then pass that in this else leave it empty.
                                ).format(controller.likeDisLike[widget.index].totalLikes)}',
                                style:
                                    FontTextStyle.kWhite17W400Roboto.copyWith(
                                  fontSize: Get.height * 0.0185,
                                ),
                              ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.to(com.CommentScreen(
                          postId: widget.postId,
                        ));
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 2.0, vertical: 2),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.comment,
                              color: ColorUtils.kTint,
                              height: Get.height * 0.025,
                              width: Get.height * 0.025,
                            ),
                            SizedBox(
                              width: Get.width * 0.02,
                            ),
                            controller.likeDisLike[widget.index].totalComments
                                        .toString()
                                        .length <=
                                    3
                                ? Text(
                                    '${controller.likeDisLike[widget.index].totalComments}',
                                    style: FontTextStyle.kWhite17W400Roboto
                                        .copyWith(
                                      fontSize: Get.height * 0.0185,
                                    ),
                                  )
                                : Text(
                                    '${NumberFormat.compactCurrency(
                                      decimalDigits: 2,
                                      symbol:
                                          '', // if you want to add currency symbol then pass that in this else leave it empty.
                                    ).format(controller.likeDisLike[widget.index].totalComments)}',
                                    style: FontTextStyle.kWhite17W400Roboto
                                        .copyWith(
                                      fontSize: Get.height * 0.0185,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * 0.015),
            child: Column(
              children: [
                GetBuilder<ForumViewModel>(
                  builder: (controller) {
                    return Column(
                      children: [
                        boxHeader(
                            controller: controller,
                            index: widget.index,
                            response: widget.response),
                        boxBody(
                            response: widget.response,
                            index: widget.index,
                            forumViewModel: controller)
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                ListView.builder(
                  // controller: scrollController,
                  itemCount:
                      widget.response!.data![widget.index].postImage!.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == 3) {
                      print('>>');
                    }
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * 0.02),
                        child: widget.response!.data![widget.index]
                                .postImage![index].isVideoFileName
                            ? Container(
                                height: Get.height * 0.37,
                                width: Get.width,
                                child: Stack(
                                  fit: StackFit.loose,
                                  children: [
                                    ForumVideoScreen(
                                        isPlay:
                                            _current == index ? true : false,
                                        height: Get.height * 0.37,
                                        video: widget
                                            .response!
                                            .data![widget.index]
                                            .postImage![index]),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(PostDetailsScreen(
                                          showFotter: false,
                                          isVideo: true,
                                          index: index,
                                          postId: widget.postId,
                                          url:
                                              '${widget.response!.data![widget.index].postImage![index]}',
                                        ));
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        height: Get.height,
                                        width: Get.width,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Get.to(PostDetailsScreen(
                                    showFotter: false,
                                    isVideo: false,
                                    index: index,
                                    postId: widget.postId,
                                    url:
                                        '${widget.response!.data![widget.index].postImage![index]}',
                                  ));
                                },
                                child: Container(
                                  height: Get.height * 0.37,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${widget.response!.data![widget.index].postImage![index]}',
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        SizedBox(),
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Shimmer.fromColors(
                                      baseColor: Colors.white.withOpacity(0.4),
                                      highlightColor:
                                          Colors.white.withOpacity(0.2),
                                      enabled: true,
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget boxHeader(
      {GetAllForumsResponseModel? response,
      int? index,
      ForumViewModel? controller}) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Get.height * 0.015, horizontal: Get.width * 0.025),
          child: Row(
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
                              /* image: DecorationImage(
                                    image: response!.data![index!].profilePic ==
                                            ''
                                        ? NetworkImage(
                                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                          )
                                        : NetworkImage(
                                            response.data![index].profilePic!),
                                    fit: BoxFit.cover)*/
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${response!.data![index!].profilePic!}',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Image.network(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                ),
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Shimmer.fromColors(
                                  baseColor: Colors.white.withOpacity(0.4),
                                  highlightColor: Colors.white.withOpacity(0.2),
                                  enabled: true,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )),
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
                    /* image: DecorationImage(
                          image: response!.data![index!].profilePic == ''
                              ? NetworkImage(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                )
                              : NetworkImage(response.data![index].profilePic!),
                          fit: BoxFit.cover)*/
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: '${response!.data![index!].profilePic!}',
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Image.network(
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                      ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Shimmer.fromColors(
                        baseColor: Colors.white.withOpacity(0.4),
                        highlightColor: Colors.white.withOpacity(0.2),
                        enabled: true,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
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
              ),
              Spacer(),
              PopupMenuButton<Options>(
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
                        SearchForumRequestModel model =
                            SearchForumRequestModel();
                        model.title = controller!.allPost;
                        model.userId = PreferenceManager.getUId();

                        if (forumViewModel.selectedMenu.value == 'All Posts') {
                          await forumViewModel.searchForumViewModel(model);
                        } else if (forumViewModel.selectedMenu.value ==
                            'Hot Posts') {
                          await forumViewModel.getAllForumsViewModel(
                              filter: 'hot');
                        } else if (forumViewModel.selectedMenu.value ==
                            'Popular Posts') {
                          await forumViewModel.getAllForumsViewModel(
                              filter: 'popular');
                        }
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Options>>[
                        PopupMenuItem<Options>(
                          value: Options.report,
                          child: Text(
                            'Report',
                            style: FontTextStyle.kWhite16W300Roboto,
                          ),
                        ),
                        response.data![index].userId ==
                                PreferenceManager.getUId()
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
                      ])
            ],
          ),
        ),
      ],
    );
  }

  Widget boxBody(
      {GetAllForumsResponseModel? response,
      int? index,
      ForumViewModel? forumViewModel}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
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
}
