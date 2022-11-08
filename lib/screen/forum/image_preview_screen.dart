import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/forum_viewModel/add_forum_viewmodel.dart';
import 'package:tcm/viewModel/forum_viewModel/all_comment_viewmodel.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ImagePreviewScreen extends StatefulWidget {
  final File? image;
  final String path;
  final bool commentScreen;
  final String? postId;
  const ImagePreviewScreen(
      {Key? key,
      this.image,
      required this.commentScreen,
      this.postId,
      required this.path})
      : super(key: key);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  ScrollController? scrollcontroller = ScrollController();
  AllCommentViewModel allCommentViewModel = Get.put(AllCommentViewModel());
  TextEditingController captionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectivityCheckViewModel.startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
      return control.isOnline
          ? widget.commentScreen == false
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
                  body: Image.file(
                    widget.image!,
                    width: Get.width,
                    height: Get.height,
                    fit: BoxFit.contain,
                  ))
              : Container(
                  width: Get.width,
                  height: Get.height,
                  decoration: BoxDecoration(
                      color: ColorUtils.kBlack,
                      image: DecorationImage(
                        image: FileImage(widget.image!),
                        fit: BoxFit.contain,
                      )),
                  child: Scaffold(
                      resizeToAvoidBottomInset: true,
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        elevation: 0,
                        bottom: PreferredSize(
                            preferredSize: Size.fromHeight(5),
                            child: GetBuilder<AllCommentViewModel>(
                              builder: (controller) {
                                return controller.loader == false
                                    ? SizedBox()
                                    : LinearProgressIndicator(
                                        color: ColorUtils.kTint,
                                        minHeight: 5,
                                        backgroundColor: ColorUtils.kBlack,
                                      );
                              },
                            )),
                        leading: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_sharp,
                              color: ColorUtils.kTint,
                            )),
                        actions: [
                          GetBuilder<AllCommentViewModel>(
                            builder: (controller) {
                              return TextButton(
                                onPressed: () async {
                                  controller.setLoaderValue(true);
                                  print('Post added >>>> ${widget.postId}');
                                  var request = http.MultipartRequest(
                                      'POST',
                                      Uri.parse(
                                          'https://tcm.sataware.dev/json/data_forum_comments.php'));
                                  request.fields.addAll({
                                    'post_id': widget.postId.toString(),
                                    'user_id': PreferenceManager.getUId(),
                                    'comment': '',
                                    'type': 'image',
                                    'caption': captionController.text
                                  });
                                  request.files.add(
                                      await http.MultipartFile.fromPath(
                                          'image[]', widget.path));

                                  http.StreamedResponse response =
                                      await request.send();

                                  if (response.statusCode == 200) {
                                    print(
                                        await response.stream.bytesToString());

                                    captionController.clear();
                                    await controller
                                        .getAllCommentsViewModel(
                                      postId: widget.postId,
                                    )
                                        .then((value) {
                                      Future.delayed(Duration(seconds: 2), () {
                                        scrollcontroller!.animateTo(
                                          scrollcontroller!
                                              .position.maxScrollExtent,
                                          duration: Duration(seconds: 1),
                                          curve: Curves.fastOutSlowIn,
                                        );
                                      });
                                      Get.back();
                                      controller.setLoaderValue(false);
                                      Get.showSnackbar(GetSnackBar(
                                        duration: Duration(seconds: 2),
                                        messageText: Text(
                                          'Comment added....',
                                          style:
                                              FontTextStyle.kTine17BoldRoboto,
                                        ),
                                      ));
                                    });
                                  } else {
                                    controller.setLoaderValue(false);

                                    print(response.reasonPhrase);
                                    Get.showSnackbar(GetSnackBar(
                                      duration: Duration(seconds: 2),
                                      messageText: Text(
                                        'Comment not created',
                                        style: FontTextStyle.kTine17BoldRoboto,
                                      ),
                                    ));
                                  }
                                },
                                child: controller.loader == false
                                    ? Text(
                                        "Post",
                                        style: TextStyle(
                                            color: ColorUtils.kTint,
                                            fontSize: 18),
                                      )
                                    : SizedBox(),
                              );
                            },
                          )
                        ],
                        backgroundColor: ColorUtils.kBlack,
                      ),
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GetBuilder<AllCommentViewModel>(
                            builder: (controller) {
                              return Container(
                                color: Colors.black,
                                child: Container(
                                  height: Get.height * 0.068,
                                  color: ColorUtils.kTint.withOpacity(0.2),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.height * 0.015),
                                    child: TextField(
                                      controller: captionController,
                                      style: FontTextStyle.kWhite17W400Roboto,
                                      decoration: InputDecoration(
                                        hintText: 'Add a caption.....',
                                        hintStyle:
                                            FontTextStyle.kWhite17W400Roboto,
                                        border: InputBorder.none,

                                        /* suffixIcon: controller
                                              .addCommentApiResponse.status ==
                                          Status.LOADING
                                      ? Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: CircularProgressIndicator(
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
                                            */
                                        /*   dio.FormData formData =
                                                    dio.FormData.fromMap({
                                                  'post_id':
                                                      widget.postId.toString(),
                                                  'user_id': PreferenceManager
                                                      .getUId(),
                                                  'image[]': await dio
                                                          .MultipartFile
                                                      .fromFile(
                                                          widget.image!.path,
                                                          filename:
                                                              'Image_${DateTime.now().millisecondsSinceEpoch}.jpg'),
                                                  'comment': '',
                                                  'type': 'image',
                                                  'caption':
                                                      captionController.text
                                                });
                                                print('$');
                                                dio.Response response =
                                                    await dio.Dio().post(
                                                        "https://tcm.sataware.dev/json/data_forum_comments.php",
                                                        data: formData);
                                                print(response);
                                                if (response.data != null) {
                                                  captionController.clear();
                                                  await controller
                                                      .getAllCommentsViewModel(
                                                    postId: widget.postId,
                                                  )
                                                      .then((value) {
                                                    Future.delayed(
                                                        Duration(seconds: 2),
                                                        () {
                                                      scrollcontroller!
                                                          .animateTo(
                                                        scrollcontroller!
                                                            .position
                                                            .maxScrollExtent,
                                                        duration: Duration(
                                                            seconds: 1),
                                                        curve: Curves
                                                            .fastOutSlowIn,
                                                      );
                                                    });
                                                    Get.back();
                                                    Get.showSnackbar(
                                                        GetSnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      messageText: Text(
                                                        'Comment added....',
                                                        style: FontTextStyle
                                                            .kTine17BoldRoboto,
                                                      ),
                                                    ));
                                                  });
                                                  return response.data['url'];
                                                } else {
                                                  Get.showSnackbar(GetSnackBar(
                                                    duration:
                                                        Duration(seconds: 2),
                                                    messageText: Text(
                                                      'Comment not created',
                                                      style: FontTextStyle
                                                          .kTine17BoldRoboto,
                                                    ),
                                                  ));
                                                  return null;
                                                }*/
                                        /*

                                            print(
                                                'Post added >>>> ${widget.postId}');
                                            var request = http.MultipartRequest(
                                                'POST',
                                                Uri.parse(
                                                    'https://tcm.sataware.dev/json/data_forum_comments.php'));
                                            request.fields.addAll({
                                              'post_id':
                                                  widget.postId.toString(),
                                              'user_id':
                                                  PreferenceManager.getUId(),
                                              'comment': '',
                                              'type': 'image',
                                              'caption':
                                                  captionController.text
                                            });
                                            request.files.add(await http
                                                    .MultipartFile
                                                .fromPath(
                                                    'image[]', widget.path));

                                            http.StreamedResponse response =
                                                await request.send();

                                            if (response.statusCode == 200) {
                                              print(await response.stream
                                                  .bytesToString());

                                              captionController.clear();
                                              await controller
                                                  .getAllCommentsViewModel(
                                                postId: widget.postId,
                                              )
                                                  .then((value) {
                                                Future.delayed(
                                                    Duration(seconds: 2), () {
                                                  scrollcontroller!.animateTo(
                                                    scrollcontroller!.position
                                                        .maxScrollExtent,
                                                    duration:
                                                        Duration(seconds: 1),
                                                    curve:
                                                        Curves.fastOutSlowIn,
                                                  );
                                                });
                                                Get.back();
                                                Get.showSnackbar(GetSnackBar(
                                                  duration:
                                                      Duration(seconds: 2),
                                                  messageText: Text(
                                                    'Comment added....',
                                                    style: FontTextStyle
                                                        .kTine17BoldRoboto,
                                                  ),
                                                ));
                                              });
                                            } else {
                                              print(response.reasonPhrase);
                                              Get.showSnackbar(GetSnackBar(
                                                duration:
                                                    Duration(seconds: 2),
                                                messageText: Text(
                                                  'Comment not created',
                                                  style: FontTextStyle
                                                      .kTine17BoldRoboto,
                                                ),
                                              ));
                                            }
                                            */
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )),
                )
          : ConnectionCheckScreen();
    });
  }
}
