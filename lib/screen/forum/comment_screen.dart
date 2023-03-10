import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/forum_request_model/add_comments_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_comments_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/forum/compress_video_screen.dart';
import 'package:tcm/screen/forum/forum_video_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';

import '../../model/request_model/forum_request_model/search_forum_request_model.dart';
import '../../viewModel/forum_viewModel/all_comment_viewmodel.dart';
import '../../viewModel/forum_viewModel/forum_viewmodel.dart';
import 'image_preview_screen.dart';

enum Options { delete }

class CommentScreen extends StatefulWidget {
  final String? postId;
  const CommentScreen({Key? key, this.postId}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  AllCommentViewModel allCommentViewModel = Get.put(AllCommentViewModel());
  ForumViewModel forumViewModel = Get.put(ForumViewModel());
  TextEditingController commentController = TextEditingController();
  ScrollController? scrollcontroller = ScrollController();
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  bool _keyboardVisible = false;
  String _selectedOptions = '';
  ImagePicker _picker = ImagePicker();
  File? selectFile;

  @override
  void initState() {
    // TODO: implement initState
    _connectivityCheckViewModel.startMonitoring();
    allCommentViewModel.textFiledValue = "";

    data();
    super.initState();
  }

  void data() async {
    await allCommentViewModel.getAllCommentsViewModel(
      postId: widget.postId,
    );
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    print('_keyboardVisible>>>>>>$_keyboardVisible');
    return GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
      return control.isOnline
          ? WillPopScope(
              onWillPop: () async {
                if (forumViewModel.selectedMenu == 'All Posts') {
                  SearchForumRequestModel model = SearchForumRequestModel();
                  model.title = '';
                  model.userId = PreferenceManager.getUId();
                  await forumViewModel.searchForumViewModel(model);
                } else if (forumViewModel.selectedMenu == 'Popular Posts') {
                  await forumViewModel.getAllForumsViewModel(filter: 'popular');
                } else if (forumViewModel.selectedMenu == 'Hot Posts') {
                  await forumViewModel.getAllForumsViewModel(filter: 'hot');
                }

                Get.back();
                return true;
              },
              child: Scaffold(
                backgroundColor: ColorUtils.kBlack,
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () async {
                        if (forumViewModel.selectedMenu == 'All Posts') {
                          SearchForumRequestModel model =
                              SearchForumRequestModel();
                          model.title = '';
                          model.userId = PreferenceManager.getUId();
                          await forumViewModel.searchForumViewModel(model);
                        } else if (forumViewModel.selectedMenu ==
                            'Popular Posts') {
                          await forumViewModel.getAllForumsViewModel(
                              filter: 'popular');
                        } else if (forumViewModel.selectedMenu == 'Hot Posts') {
                          await forumViewModel.getAllForumsViewModel(
                              filter: 'hot');
                        }

                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: ColorUtils.kTint,
                      )),
                  backgroundColor: ColorUtils.kBlack,
                  title:
                      Text('Comments', style: FontTextStyle.kWhite16BoldRoboto),
                  centerTitle: true,
                ),
                body: RefreshIndicator(
                  color: Colors.black,
                  onRefresh: () async {
                    // await allCommentViewModel.getAllCommentsViewModel(
                    //   postId: widget.postId,
                    // );
                  },
                  child: Container(
                    height: Get.height,
                    child: Column(
                      children: [
                        GetBuilder<AllCommentViewModel>(builder: (controller) {
                          if (controller.getAllCommentsApiResponse.status ==
                              Status.LOADING) {
                            return Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: CircularProgressIndicator(
                                color: ColorUtils.kTint,
                              ),
                            ));
                          }
                          if (controller.getAllCommentsApiResponse.status ==
                              Status.ERROR) {
                            return Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'Server Error',
                                style: FontTextStyle.kTine16W400Roboto,
                              ),
                            ));
                          }

                          GetAllCommentsResponseModel response =
                              controller.getAllCommentsApiResponse.data;
                          if (response.data!.isEmpty) {
                            return Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'No Comments',
                                style: FontTextStyle.kTine16W400Roboto,
                              ),
                            ));
                          }

                          return Expanded(
                            child: ListView.builder(
                              controller: scrollcontroller,
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.height * 0.02,
                                  vertical: Get.height * 0.02),
                              itemCount: response.data!.length,
                              itemBuilder: (context, index) {
                                print(
                                    'image >>> ${response.data![index].image}');
                                return Column(
                                  children: [
                                    Container(
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                          color: ColorUtils.kSaperatedGray
                                              .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.height * 0.015,
                                            vertical: Get.height * 0.01),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Get.dialog(Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height:
                                                                    Get.height *
                                                                        0.3,
                                                                width:
                                                                    Get.height *
                                                                        0.3,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      ColorUtils
                                                                          .kBlack,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  /* image: DecorationImage(
                                                                      image: response.data![index].userProfilePic == ''
                                                                          ? NetworkImage(
                                                                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                                                            )
                                                                          : NetworkImage(response.data![index].userProfilePic!),
                                                                      fit: BoxFit.cover),*/
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              150),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        '${response.data![index].userProfilePic!}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .network(
                                                                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                                                    ),
                                                                    progressIndicatorBuilder: (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        Shimmer
                                                                            .fromColors(
                                                                      baseColor: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.4),
                                                                      highlightColor: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.2),
                                                                      enabled:
                                                                          true,
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    Get.height *
                                                                        0.02,
                                                              ),
                                                              Material(
                                                                color: Colors
                                                                    .transparent,
                                                                child: Text(
                                                                  '${response.data![index].userFullName} ',
                                                                  style: FontTextStyle
                                                                      .kWhite20BoldRoboto,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ));
                                                      },
                                                      child: Container(
                                                        height:
                                                            Get.height * 0.04,
                                                        width:
                                                            Get.height * 0.04,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              ColorUtils.kBlack,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: ColorUtils
                                                                  .kTint),
                                                          /*image: DecorationImage(
                                                                image: NetworkImage(
                                                                    '${response.data![index].userProfilePic}'),
                                                                fit: BoxFit
                                                                    .cover)*/
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                '${response.data![index].userProfilePic}',
                                                            fit: BoxFit.cover,
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                Image.network(
                                                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png',
                                                            ),
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                        downloadProgress) =>
                                                                    Shimmer
                                                                        .fromColors(
                                                              baseColor: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.4),
                                                              highlightColor:
                                                                  Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.2),
                                                              enabled: true,
                                                              child: Container(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.03,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${response.data![index].userFullName} ',
                                                          style: FontTextStyle
                                                              .kWhite17W400Roboto
                                                              .copyWith(
                                                                  fontSize:
                                                                      Get.height *
                                                                          0.018),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              Get.width * 0.01,
                                                        ),
                                                        Icon(
                                                          Icons.circle,
                                                          size: Get.height *
                                                              0.007,
                                                          color: ColorUtils
                                                              .kLightGray,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              Get.width * 0.01,
                                                        ),
                                                        Text(
                                                          '${response.data![index].postDate} ',
                                                          style: FontTextStyle
                                                              .kLightGray16W300Roboto
                                                              .copyWith(
                                                                  fontSize:
                                                                      Get.height *
                                                                          0.018),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                response.data![index].userId ==
                                                        PreferenceManager
                                                            .getUId()
                                                    ? Positioned(
                                                        top: -10,
                                                        right: -10,
                                                        child: PopupMenuButton<
                                                                Options>(
                                                            color: ColorUtils
                                                                .kBlack,
                                                            icon: Icon(
                                                              Icons.more_vert,
                                                              color: ColorUtils
                                                                  .kTint,
                                                              size: Get.height *
                                                                  0.025,
                                                            ),
                                                            // Callback that sets the selected popup menu item.
                                                            onSelected: (Options
                                                                item) async {
                                                              setState(() {
                                                                _selectedOptions =
                                                                    item.name;
                                                              });
                                                              if (_selectedOptions ==
                                                                  'report') {
                                                              } else {
                                                                await forumViewModel
                                                                    .deleteCommentViewModel(
                                                                        userId: PreferenceManager
                                                                            .getUId(),
                                                                        commentId: response
                                                                            .data![
                                                                                index]
                                                                            .commentId)
                                                                    .then(
                                                                        (value) async {
                                                                  Get.showSnackbar(
                                                                      GetSnackBar(
                                                                    duration: Duration(
                                                                        seconds:
                                                                            2),
                                                                    messageText:
                                                                        Text(
                                                                      'Post deleted successfully....',
                                                                      style: FontTextStyle
                                                                          .kTine17BoldRoboto,
                                                                    ),
                                                                  ));

                                                                  await controller
                                                                      .getAllCommentsViewModel(
                                                                    postId: widget
                                                                        .postId,
                                                                  );
                                                                  ;
                                                                });
                                                              }
                                                            },
                                                            itemBuilder: (BuildContext
                                                                    context) =>
                                                                <
                                                                    PopupMenuEntry<
                                                                        Options>>[
                                                                  PopupMenuItem<
                                                                      Options>(
                                                                    height:
                                                                        Get.height *
                                                                            0.04,
                                                                    value: Options
                                                                        .delete,
                                                                    child: Text(
                                                                      'Delete',
                                                                      style: FontTextStyle
                                                                          .kWhite16W300Roboto,
                                                                    ),
                                                                  )
                                                                ]),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            response.data![index].type ==
                                                        "video" ||
                                                    response.data![index]
                                                            .type ==
                                                        "image"
                                                ? SizedBox(
                                                    height: Get.height * 0.02,
                                                  )
                                                : SizedBox(),
                                            response.data![index].type ==
                                                    "video"
                                                ? Center(
                                                    child: Container(
                                                      height: Get.height * 0.23,
                                                      width: Get.width,
                                                      child: ForumVideoScreen(
                                                          video:
                                                              "${response.data![index].image}"),
                                                    ),
                                                  )
                                                // SizedBox()
                                                : response.data![index].type ==
                                                        "image"
                                                    ? Container(
                                                        width: Get.width,
                                                        height:
                                                            Get.height * 0.23,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              "${response.data![index].image}",
                                                          // "https://tcm.sataware.dev/images/uploads/Image_1667626030138_2022-11-05_1667626037.jpg",
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              SizedBox(),
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  Shimmer
                                                                      .fromColors(
                                                            baseColor: Colors
                                                                .white
                                                                .withOpacity(
                                                                    0.4),
                                                            highlightColor:
                                                                Colors.white
                                                                    .withOpacity(
                                                                        0.2),
                                                            enabled: true,
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                            SizedBox(
                                              height: Get.height * 0.02,
                                            ),
                                            response.data![index].caption!
                                                        .isEmpty ||
                                                    response.data![index]
                                                            .caption ==
                                                        ""
                                                ? SizedBox()
                                                : Text(
                                                    '${response.data![index].caption} ',
                                                    style: FontTextStyle
                                                        .kLightGray16W300Roboto,
                                                  ),
                                            response.data![index].comment!
                                                        .isEmpty ||
                                                    response.data![index]
                                                            .comment ==
                                                        ""
                                                ? SizedBox()
                                                : Text(
                                                    '${response.data![index].comment} ',
                                                    style: FontTextStyle
                                                        .kLightGray16W300Roboto,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    )
                                  ],
                                );
                              },
                            ),
                          );
                        }),
                        GetBuilder<AllCommentViewModel>(
                          builder: (controller) {
                            if (controller.getAllCommentsApiResponse.status ==
                                Status.LOADING) {
                              return Spacer();
                            }
                            if (controller.getAllCommentsApiResponse.status ==
                                Status.ERROR) {
                              return Spacer();
                            }
                            GetAllCommentsResponseModel response =
                                controller.getAllCommentsApiResponse.data;

                            return response.data!.isEmpty
                                ? Spacer()
                                : SizedBox();
                          },
                        ),
                        GetBuilder<AllCommentViewModel>(
                          builder: (controller) {
                            return Container(
                              height: Get.height * 0.06,
                              color: ColorUtils.kTint.withOpacity(0.2),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.height * 0.02),
                                child: TextField(
                                  controller: commentController,
                                  style: FontTextStyle.kWhite17W400Roboto,
                                  onChanged: (value) {
                                    controller.setTextFiledValue(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Add Comment.....',
                                    hintStyle: FontTextStyle.kWhite17W400Roboto,
                                    border: InputBorder.none,
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        controller.textFiledValue != ""
                                            ? SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    final image =
                                                        await _picker.pickImage(
                                                            source: ImageSource
                                                                .gallery);
                                                    if (image != null) {
                                                      selectFile =
                                                          File(image.path);
                                                      print(
                                                          'imageimage? ${image}');
                                                      print(
                                                          'imageimage? $selectFile');
                                                      Get.to(ImagePreviewScreen(
                                                        path: image.path,
                                                        postId: widget.postId,
                                                        commentScreen: true,
                                                        image: selectFile!,
                                                      ));
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons.camera_alt_outlined,
                                                    color: ColorUtils.kTint,
                                                    size: Get.height * 0.03,
                                                  ),
                                                ),
                                              ),
                                        controller.textFiledValue != ""
                                            ? SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    final image =
                                                        await _picker.pickVideo(
                                                            source: ImageSource
                                                                .gallery);
                                                    if (image != null) {
                                                      setState(() {
                                                        selectFile =
                                                            File(image.path);
                                                      });
                                                      print(
                                                          'imageimage? ${image}');
                                                      print(
                                                          'imageimage? $selectFile');
                                                      Get.to(TrimmerView(
                                                          selectFile!,
                                                          true,
                                                          widget.postId
                                                              .toString()));
                                                      // Get.back();
                                                      /* final uint8list =
                                                          await VideoThumbnail
                                                              .thumbnailData(
                                                        video: selectFile!.path,
                                                        imageFormat:
                                                            ImageFormat.JPEG,
                                                        maxHeight: 250,
                                                        maxWidth: 250,
                                                        quality: 50,
                                                      );
                                                      Uint8List imageInUnit8List =
                                                          uint8list!; // store unit8List image here ;
                                                      final tempDir =
                                                          await getTemporaryDirectory();
                                                      File file = await File(
                                                              '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png')
                                                          .create();
                                                      file.writeAsBytesSync(
                                                          imageInUnit8List);

                                                      var a = await videoInfo
                                                          .getVideoInfo(
                                                              selectFile!.path);

                                                      setState(() {
                                                        filesAll.add({
                                                          'type': 'mp4',
                                                          'file':
                                                              File(image.path),
                                                          'thumbnail': file,
                                                          'size': a!.filesize,
                                                          'duration': a.duration,
                                                        });
                                                      });*/
                                                    }
                                                  },
                                                  icon: Icon(
                                                    Icons
                                                        .video_camera_back_outlined,
                                                    color: ColorUtils.kTint,
                                                    size: Get.height * 0.03,
                                                  ),
                                                ),
                                              ),
                                        controller.textFiledValue == ""
                                            ? SizedBox()
                                            : controller.addCommentApiResponse
                                                        .status ==
                                                    Status.LOADING
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: ColorUtils.kTint,
                                                    ),
                                                  )
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.send,
                                                      color: ColorUtils.kTint,
                                                      size: Get.height * 0.03,
                                                    ),
                                                    onPressed: () async {
                                                      controller
                                                          .textFiledValue = "";
                                                      AddCommentRequestModel
                                                          model =
                                                          AddCommentRequestModel();
                                                      model.postId =
                                                          widget.postId;
                                                      model.userId =
                                                          PreferenceManager
                                                              .getUId();
                                                      model.comment =
                                                          commentController
                                                              .text;
                                                      model.type = "text";
                                                      model.caption = "";
                                                      model.image = "";
                                                      commentController.clear();
                                                      print(
                                                          'model ${model.toJson()}');
                                                      await controller
                                                          .addCommentsViewModel(
                                                              model)
                                                          .then((value) async {
                                                        await controller
                                                            .getAllCommentsViewModel(
                                                          postId: widget.postId,
                                                        )
                                                            .then((value) {
                                                          Future.delayed(
                                                              Duration(
                                                                  seconds: 2),
                                                              () {
                                                            scrollcontroller!
                                                                .animateTo(
                                                              scrollcontroller!
                                                                  .position
                                                                  .maxScrollExtent,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              curve: Curves
                                                                  .fastOutSlowIn,
                                                            );
                                                          });
                                                        });
                                                      });
                                                    }),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : ConnectionCheckScreen();
    });
  }
}
