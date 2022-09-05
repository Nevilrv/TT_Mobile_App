// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:tcm/preference_manager/preference_store.dart';
// import 'package:tcm/utils/ColorUtils.dart';
// import 'package:tcm/utils/font_styles.dart';
//
// import '../../model/request_model/forum_request_model/like_forum_request_model.dart';
// import '../../model/response_model/forum_response_model/get_all_forums_response_model.dart';
// import '../../utils/images.dart';
// import '../../viewModel/forum_viewModel/forum_viewmodel.dart';
// import 'comment_screen.dart';
//
// class ForumDetailScreen extends StatefulWidget {
//   final Datum? response;
//   final int? index;
//   final ForumViewModel? forumViewModel;
//   ForumDetailScreen({Key? key, this.response, this.forumViewModel, this.index})
//       : super(key: key);
//
//   @override
//   _ForumDetailScreenState createState() => _ForumDetailScreenState();
// }
//
// class _ForumDetailScreenState extends State<ForumDetailScreen> {
//   bool isLike = false;
//   bool isUnLike = false;
//   ForumViewModel forumViewModel = Get.put(ForumViewModel());
//   @override
//   Widget build(BuildContext context) {
//     print('Preference ${PreferenceManager.getUId()}');
//     return Scaffold(
//       backgroundColor: ColorUtils.kBlack,
//       body: Padding(
//         padding: EdgeInsets.symmetric(
//             horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: Get.height * 0.03,
//               ),
//               IconButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: ColorUtils.kTint,
//                   )),
//               SizedBox(
//                 height: Get.height * 0.02,
//               ),
//               Text(
//                 '${widget.response!.postTitle!.replaceFirst(widget.response!.postTitle![0], widget.response!.postTitle![0].toUpperCase())}',
//                 style: FontTextStyle.kWhite12BoldRoboto.copyWith(
//                   fontSize: Get.height * 0.023,
//                 ),
//               ),
//               SizedBox(
//                 height: Get.height * 0.02,
//               ),
//               Text(
//                 '#${widget.response!.tagTitle}',
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: FontTextStyle.kTine17BoldRoboto.copyWith(
//                   fontSize: Get.height * 0.0185,
//                 ),
//               ),
//               SizedBox(
//                 height: Get.height * 0.02,
//               ),
//               Row(
//                 children: [
//                   Text(
//                     'Posted By ${widget.response!.userName}',
//                     style: FontTextStyle.kLightGray16W300Roboto.copyWith(
//                         fontSize: Get.height * 0.018,
//                         color: Colors.white.withOpacity(0.8)),
//                   ),
//                   SizedBox(
//                     width: Get.width * 0.02,
//                   ),
//                   Icon(
//                     Icons.circle,
//                     size: Get.height * 0.007,
//                     color: ColorUtils.kLightGray,
//                   ),
//                   SizedBox(
//                     width: Get.width * 0.02,
//                   ),
//                   Text(
//                     '${widget.response!.postDate}',
//                     style: FontTextStyle.kLightGray16W300Roboto
//                         .copyWith(fontSize: Get.height * 0.02),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: Get.height * 0.02,
//               ),
//               GetBuilder<ForumViewModel>(
//                 builder: (controller) {
//                   return Padding(
//                     padding:
//                         EdgeInsets.symmetric(horizontal: Get.height * 0.01),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: () async {
//                                 if (controller
//                                         .likeDisLike[widget.index!].userLiked ==
//                                     0) {
//                                   controller
//                                       .likeDisLike[widget.index!].userLiked = 1;
//                                   controller.likeDisLike[widget.index!]
//                                       .userDisLiked = 0;
//                                   controller.likeDisLike[widget.index!]
//                                       .totalLike = controller
//                                           .likeDisLike[widget.index!]
//                                           .totalLike! +
//                                       1;
//                                   LikeForumRequestModel model =
//                                       LikeForumRequestModel();
//                                   model.postId = widget.response!.postId;
//                                   model.userId = PreferenceManager.getUId();
//                                   model.like = '1';
//                                   model.disLike = '0';
//                                   await controller.likeForumViewModel(model);
//                                 } else if (controller
//                                         .likeDisLike[widget.index!].userLiked ==
//                                     1) {
//                                   controller
//                                       .likeDisLike[widget.index!].userLiked = 0;
//                                   controller.likeDisLike[widget.index!]
//                                       .totalLike = controller
//                                           .likeDisLike[widget.index!]
//                                           .totalLike! -
//                                       1;
//                                   LikeForumRequestModel model =
//                                       LikeForumRequestModel();
//                                   model.postId = widget.response!.postId;
//                                   model.userId = PreferenceManager.getUId();
//                                   model.like = '0';
//                                   model.disLike = '0';
//                                   await controller.likeForumViewModel(model);
//                                 }
//                               },
//                               child: controller!.likeDisLike[widget.index!]
//                                           .userLiked ==
//                                       0
//                                   ? Image.asset(
//                                       AppImages.arrowUpBorder,
//                                       color: ColorUtils.kTint,
//                                       height: Get.height * 0.022,
//                                       width: Get.height * 0.022,
//                                     )
//                                   : Image.asset(
//                                       AppImages.arrowUp,
//                                       color: ColorUtils.kTint,
//                                       height: Get.height * 0.022,
//                                       width: Get.height * 0.022,
//                                     ),
//                             ),
//                             SizedBox(
//                               width: Get.width * 0.02,
//                             ),
//                             Text(
//                               '${controller.likeDisLike[widget.index!].totalLike}',
//                               style: FontTextStyle.kWhite17W400Roboto.copyWith(
//                                 fontSize: Get.height * 0.0185,
//                               ),
//                             ),
//                             SizedBox(
//                               width: Get.width * 0.02,
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   isUnLike = !isUnLike;
//                                 });
//                               },
//                               child: isUnLike == false
//                                   ? Image.asset(
//                                       AppImages.arrowDownBorder,
//                                       color: ColorUtils.kTint,
//                                       height: Get.height * 0.022,
//                                       width: Get.height * 0.022,
//                                     )
//                                   : Image.asset(
//                                       AppImages.arrowDown,
//                                       color: ColorUtils.kTint,
//                                       height: Get.height * 0.022,
//                                       width: Get.height * 0.022,
//                                     ),
//                             ),
//                           ],
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             // await forumViewModel.getAllCommentsViewModel(
//                             //   postId: widget.response!.postId,
//                             // );
//                             Get.to(CommentScreen(
//                               postId: widget.response!.postId,
//                             ));
//                           },
//                           child: Row(
//                             children: [
//                               Image.asset(
//                                 AppImages.comment,
//                                 color: ColorUtils.kTint,
//                                 height: Get.height * 0.022,
//                                 width: Get.height * 0.022,
//                               ),
//                               SizedBox(
//                                 width: Get.width * 0.02,
//                               ),
//                               Text(
//                                 '2.3k',
//                                 style:
//                                     FontTextStyle.kWhite17W400Roboto.copyWith(
//                                   fontSize: Get.height * 0.0185,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             Share.share(widget.response!.postTitle!,
//                                 subject: widget.response!.postDescription!);
//                           },
//                           child: Row(
//                             children: [
//                               Image.asset(
//                                 AppImages.share,
//                                 color: ColorUtils.kTint,
//                                 height: Get.height * 0.022,
//                                 width: Get.height * 0.022,
//                               ),
//                               SizedBox(
//                                 width: Get.width * 0.02,
//                               ),
//                               Text(
//                                 'Share',
//                                 style:
//                                     FontTextStyle.kWhite17W400Roboto.copyWith(
//                                   fontSize: Get.height * 0.0185,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(
//                 height: Get.height * 0.02,
//               ),
//               Text(
//                 '${widget.response!.postDescription}',
//                 style: FontTextStyle.kLightGray16W300Roboto.copyWith(
//                     fontSize: Get.height * 0.02, color: Colors.white38),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
