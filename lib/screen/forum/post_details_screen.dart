import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tcm/model/request_model/forum_request_model/like_forum_request_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/forum/comment_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/forum_viewModel/forum_viewmodel.dart';

import 'forum_video_screen.dart';

class PostDetailsScreen extends StatefulWidget {
  final String url;
  final int index;
  final String postId;
  final bool isVideo;
  final bool showFotter;
  const PostDetailsScreen(
      {Key? key,
      required this.url,
      required this.index,
      required this.postId,
      required this.isVideo,
      required this.showFotter})
      : super(key: key);

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: widget.showFotter == false
            ? SizedBox()
            : Column(
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
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * 0.025),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    if (controller.likeDisLike[widget.index]
                                            .userLiked ==
                                        0) {
                                      controller.likeDisLike[widget.index]
                                          .userLiked = 1;
                                      controller.likeDisLike[widget.index]
                                          .userDisliked = 0;
                                      controller.likeDisLike[widget.index]
                                          .totalLikes = controller
                                              .likeDisLike[widget.index]
                                              .totalLikes! +
                                          1;
                                      LikeForumRequestModel model =
                                          LikeForumRequestModel();
                                      model.postId = widget.postId;
                                      model.userId = PreferenceManager.getUId();
                                      model.like = '1';
                                      model.disLike = '0';
                                      await controller
                                          .likeForumViewModel(model);
                                    } else if (controller
                                            .likeDisLike[widget.index]
                                            .userLiked ==
                                        1) {
                                      controller.likeDisLike[widget.index]
                                          .userLiked = 0;
                                      controller.likeDisLike[widget.index]
                                          .totalLikes = controller
                                              .likeDisLike[widget.index]
                                              .totalLikes! -
                                          1;
                                      LikeForumRequestModel model =
                                          LikeForumRequestModel();
                                      model.postId = widget.postId;
                                      model.userId = PreferenceManager.getUId();
                                      model.like = '0';
                                      model.disLike = '0';
                                      await controller
                                          .likeForumViewModel(model);
                                    }
                                  },
                                  child: controller.likeDisLike[widget.index]
                                              .userLiked ==
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
                                        ).format(controller.likeDisLike[widget.index].totalLikes)}',
                                        style: FontTextStyle.kWhite17W400Roboto
                                            .copyWith(
                                          fontSize: Get.height * 0.0185,
                                        ),
                                      ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                Get.to(CommentScreen(
                                  postId: widget.postId,
                                ));
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 2),
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
                                    controller.likeDisLike[widget.index]
                                                .totalComments
                                                .toString()
                                                .length <=
                                            3
                                        ? Text(
                                            '${controller.likeDisLike[widget.index].totalComments}',
                                            style: FontTextStyle
                                                .kWhite17W400Roboto
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
                                            style: FontTextStyle
                                                .kWhite17W400Roboto
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
        backgroundColor: ColorUtils.kBlack,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          widget.isVideo == false
              ? Center(
                  child: SizedBox(
                    child: CachedNetworkImage(
                      height: Get.height * 0.8,
                      imageUrl: widget.url,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) => SizedBox(),
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
                )
              : ForumVideoScreen(
                  isPlay: true,
                  video: widget.url,
                  height: Get.height * 0.4,
                ),
        ]),
      ),
    );
  }
}
