import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/forum_request_model/add_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_forum_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forums_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_tags_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/forum/video_preview_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/forum_viewModel/tags_viewModel.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../model/request_model/forum_request_model/search_forum_request_model.dart';
import '../../viewModel/forum_viewModel/add_forum_viewmodel.dart';
import '../../viewModel/forum_viewModel/forum_viewmodel.dart';
import 'image_preview_screen.dart';

class AddForumScreen extends StatefulWidget {
  const AddForumScreen({Key? key}) : super(key: key);

  @override
  _AddForumScreenState createState() => _AddForumScreenState();
}

class _AddForumScreenState extends State<AddForumScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController tag = TextEditingController();
  GetTagsViewModel getTagsViewModel = Get.put(GetTagsViewModel());

  AddForumViewModel addForumViewModel = Get.put(AddForumViewModel());
  ForumViewModel forumViewModel = Get.find();
  var keybardHeight = 0.0;
  List data = [];
  List<Map<String, dynamic>> filesAll = [];
  List<File> files = [];
  VideoPlayerController? _controller;
  @override
  void initState() {
    // TODO: implement initState
    getTagsViewModel.getTagsViewModel(title: '');
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      keybardHeight = MediaQuery.of(context).viewInsets.bottom;
    });
    print(
        'MediaQuery.of(context).viewInsets.bottom ${MediaQuery.of(context).viewInsets.bottom}');
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
        title: Text('Add Post', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title : ',
                    style: FontTextStyle.kGreyBoldRoboto,
                  ),
                  SizedBox(
                    height: Get.height * 0.012,
                  ),
                  TextFormField(
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Get.height * .018),
                    keyboardType: TextInputType.text,
                    controller: title,
                    decoration: InputDecoration(
                        hintText: 'Add Title....',
                        hintStyle: TextStyle(
                            color: ColorUtils.kHintTextGray,
                            fontSize: Get.height * 0.02,
                            fontWeight: FontWeight.w500),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: Get.height * 0.02,
                            vertical: Get.height * 0.02),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: ColorUtils.kTint)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: ColorUtils.kTint))),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Text(
                    'Description : ',
                    style: FontTextStyle.kGreyBoldRoboto,
                  ),
                  SizedBox(
                    height: Get.height * 0.012,
                  ),
                  TextFormField(
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Get.height * .018),
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    controller: description,
                    decoration: InputDecoration(
                        hintText: 'Add Description....',
                        hintStyle: TextStyle(
                            color: ColorUtils.kHintTextGray,
                            fontSize: Get.height * 0.02,
                            fontWeight: FontWeight.w500),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: Get.height * 0.02,
                            vertical: Get.height * 0.02),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: ColorUtils.kTint)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: ColorUtils.kTint))),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        filesAll.length >= 5
                            ? SizedBox()
                            : GestureDetector(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: [
                                        'jpg',
                                        'mp4',
                                        'png',
                                        'mov'
                                      ]);

                                  if (result != null) {
                                    files = result.paths
                                        .map((path) => File(path!))
                                        .toList();

                                    files.forEach((element) async {
                                      setState(() {});
                                      if (element.path.isVideoFileName) {
                                        final uint8list =
                                            await VideoThumbnail.thumbnailData(
                                          video: element.path,
                                          imageFormat: ImageFormat.JPEG,
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
                                        file.writeAsBytesSync(imageInUnit8List);
                                        setState(() {
                                          filesAll.add({
                                            'type': 'mp4',
                                            'file': element,
                                            'thumbnail': file
                                          });
                                        });
                                      } else {
                                        filesAll.add({
                                          'type': 'image',
                                          'file': element,
                                          'thumbnail': element
                                        });
                                      }
                                      print(
                                          'filesAll filesAll?????? ${filesAll}');
                                    });

                                    print('files >>>>${files}');
                                  } else {
                                    // User canceled the picker
                                  }
                                },
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: ColorUtils.kTint,
                                  radius: Radius.circular(10),
                                  child: Container(
                                    height: Get.height * 0.115,
                                    width: Get.height * 0.115,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Get.height * 0.02),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: ColorUtils.kTint,
                                          size: Get.height * 0.05,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Row(
                          children: List.generate(filesAll.length, (index) {
                            if (filesAll[index]['type'] == 'image') {
                              print('hello....1');
                              return Padding(
                                padding: EdgeInsets.all(Get.height * 0.007),
                                child: Stack(
                                  overflow: Overflow.visible,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(ImagePreviewScreen(
                                          image: filesAll[index]['file'],
                                        ));
                                      },
                                      child: Container(
                                        height: Get.height * 0.12,
                                        width: Get.height * 0.12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: ColorUtils.kTint)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              filesAll[index]['file'],
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                    Positioned(
                                      top: -Get.height * 0.007,
                                      right: -Get.height * 0.007,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            print('filesAll  ${filesAll}');
                                            filesAll.removeAt(index);
                                          });
                                        },
                                        child: CircleAvatar(
                                            radius: Get.height * 0.013,
                                            backgroundColor: ColorUtils.kTint,
                                            child: Center(
                                                child: Icon(
                                              Icons.clear,
                                              size: Get.height * 0.02,
                                              color: ColorUtils.kBlack,
                                            ))),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              print('hello....2');

                              return Padding(
                                padding: EdgeInsets.all(Get.height * 0.007),
                                child: Stack(
                                  overflow: Overflow.visible,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(VideoPreviewScreen(
                                          video: filesAll[index]['file'],
                                        ));
                                      },
                                      child: Container(
                                        height: Get.height * 0.12,
                                        width: Get.height * 0.12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: ColorUtils.kTint)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              filesAll[index]['thumbnail'],
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                    Positioned(
                                      top: -Get.height * 0.007,
                                      right: -Get.height * 0.007,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            print('filesAll  ${filesAll}');
                                            filesAll.removeAt(index);
                                          });
                                        },
                                        child: CircleAvatar(
                                            radius: Get.height * 0.013,
                                            backgroundColor: ColorUtils.kTint,
                                            child: Center(
                                                child: Icon(
                                              Icons.clear,
                                              size: Get.height * 0.02,
                                              color: ColorUtils.kBlack,
                                            ))),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: Icon(
                                        Icons.videocam,
                                        color: ColorUtils.kWhite,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await getTagsViewModel.getTagsViewModel(title: '');
                      tag.clear();
                      FocusNode inputNode = FocusNode();
                      void data() {
                        FocusScope.of(context).requestFocus(inputNode);
                      }

                      Get.dialog(
                        Container(
                          child: Material(
                            color: Colors.transparent,
                            textStyle:
                                TextStyle(decoration: TextDecoration.none),
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              setState(() {
                                keybardHeight =
                                    MediaQuery.of(context).viewInsets.bottom;
                              });
                              return GetBuilder<GetTagsViewModel>(
                                builder: (controller) {
                                  if (controller.getTagsApiResponse.status ==
                                      Status.LOADING) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: ColorUtils.kTint,
                                      ),
                                    );
                                  }
                                  GetTagsResponseModel response =
                                      controller.getTagsApiResponse.data;
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.04,
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                Get.back();
                                                tag.clear();
                                                controller.setSelectTagId('');
                                                controller
                                                    .setSelectedTagTitle('');
                                              },
                                              icon: Icon(
                                                Icons.clear,
                                                color: Colors.white,
                                              )),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              if (tag.text.isNotEmpty) {
                                                if (controller
                                                    .selectedTagTitle.isEmpty) {
                                                  Navigator.pop(context);
                                                  tag.clear();

                                                  controller.setSelectTagId('');
                                                  controller
                                                      .setSelectedTagTitle('');
                                                } else {
                                                  controller.valueFinal.add({
                                                    'id':
                                                        controller.selectTagId,
                                                    'title': controller
                                                        .selectedTagTitle
                                                  });

                                                  final jsonList = controller
                                                      .valueFinal
                                                      .map((item) =>
                                                          jsonEncode(item))
                                                      .toList();

                                                  // using toSet - toList strategy
                                                  final uniqueJsonList =
                                                      jsonList.toSet().toList();

                                                  // convert each item back to the original form using JSON decoding
                                                  final result = uniqueJsonList
                                                      .map((item) =>
                                                          jsonDecode(item))
                                                      .toList();

                                                  controller
                                                      .setValueFinal(result);
                                                  Navigator.pop(context);
                                                  tag.clear();

                                                  controller.setSelectTagId('');
                                                  controller
                                                      .setSelectedTagTitle('');
                                                }
                                              } else {
                                                Get.back();

                                                controller.setSelectTagId('');
                                                controller
                                                    .setSelectedTagTitle('');
                                              }
                                            },
                                            child: Text(
                                              'Done',
                                              style: FontTextStyle
                                                  .kWhite20BoldRoboto,
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.04,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.04,
                                      ),
                                      AutoSizeTextField(
                                        onChanged: (String val) async {
                                          print('val $val');
                                          await getTagsViewModel
                                              .getTagsViewModel(title: val);
                                        },
                                        fullwidth: false,
                                        onSubmitted: (val) async {
                                          if (tag.text.isNotEmpty) {
                                            if (controller
                                                .selectedTagTitle.isEmpty) {
                                              Navigator.pop(context);
                                              tag.clear();

                                              controller.setSelectTagId('');
                                              controller
                                                  .setSelectedTagTitle('');
                                            } else {
                                              controller.valueFinal.add({
                                                'id': controller.selectTagId,
                                                'title':
                                                    controller.selectedTagTitle
                                              });

                                              final jsonList = controller
                                                  .valueFinal
                                                  .map((item) =>
                                                      jsonEncode(item))
                                                  .toList();

                                              // using toSet - toList strategy
                                              final uniqueJsonList =
                                                  jsonList.toSet().toList();

                                              // convert each item back to the original form using JSON decoding
                                              final result = uniqueJsonList
                                                  .map((item) =>
                                                      jsonDecode(item))
                                                  .toList();

                                              controller.setValueFinal(result);
                                              Navigator.pop(context);
                                              tag.clear();

                                              controller.setSelectTagId('');
                                              controller
                                                  .setSelectedTagTitle('');
                                            }
                                          } else {
                                            Get.back();

                                            controller.setSelectTagId('');
                                            controller.setSelectedTagTitle('');
                                          }
                                        },
                                        minWidth: Get.height * 0.153,
                                        minFontSize: 20,
                                        wrapWords: true,
                                        stepGranularity: 2,
                                        showCursor: false,
                                        autofocus: true,
                                        controller: tag,
                                        focusNode: inputNode,
                                        maxLines: 1,
                                        onTap: () {
                                          print('hello...');
                                        },
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: ColorUtils.kTint,
                                            fontSize: Get.height * .05,
                                            decoration: TextDecoration.none,
                                            decorationColor:
                                                Colors.white.withOpacity(0.01)),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          prefixText: '#',
                                          prefixStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: ColorUtils.kTint,
                                            fontSize: Get.height * .05,
                                          ),
                                          hintText: 'TAG',
                                          hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: ColorUtils.kTint,
                                            fontSize: Get.height * .05,
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: Get.height * 0.007,
                                              horizontal: Get.height * 0.01),
                                          border: InputBorder.none,
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7)),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: Get.width,
                                        height: Get.height * 0.05,
                                        child: ListView.builder(
                                          padding: EdgeInsets.only(
                                              right: 15, left: 15),
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemCount: response.data!.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    controller.setSelectTagId(
                                                        response.data![index].id
                                                            .toString());
                                                    controller
                                                        .setSelectedTagTitle(
                                                            response
                                                                .data![index]
                                                                .title
                                                                .toString());

                                                    setState(() {
                                                      tag.text = response
                                                          .data![index]
                                                          .title!
                                                          .capitalize
                                                          .toString();
                                                    });
                                                    tag.selection = TextSelection
                                                        .fromPosition(
                                                            TextPosition(
                                                                offset: tag.text
                                                                    .length));
                                                  },
                                                  child: Container(
                                                    height: Get.height * 0.05,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color:
                                                            ColorUtils.kBlack,
                                                        border: Border.all(
                                                            color: ColorUtils
                                                                .kTint)),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Get.height *
                                                                      0.02),
                                                      child: Center(
                                                        child: Text(
                                                          '#${response.data![index].title}',
                                                          style: FontTextStyle
                                                              .kTine16W400Roboto,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.03,
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: keybardHeight,
                                      ),
                                    ],
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                        barrierColor: Colors.black.withOpacity(0.8),
                      );
                    },
                    child: Container(
                      height: Get.height * 0.05,
                      width: Get.width * 0.365,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorUtils.kTint,
                          border: Border.all(color: ColorUtils.kTint)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                        child: Center(
                          child: Text(
                            'SELECT TAG',
                            style: FontTextStyle.kBlack16BoldRoboto,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  GetBuilder<GetTagsViewModel>(
                    builder: (controller) {
                      data.clear();
                      print(
                          'controller.valueFinal.length ${controller.valueFinal.length}');

                      controller.valueFinal.forEach((element) {
                        print(element['id']);
                        data.add(element['id']);
                      });
                      print('DATA data>>>>. ${data}');
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                              controller.valueFinal.length,
                              (index1) => Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Container(
                                      height: Get.height * 0.05,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorUtils.kTint)),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.height * 0.02),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${controller.valueFinal[index1]['title']}',
                                              style: FontTextStyle
                                                  .kTint20BoldRoboto,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                controller.valueFinal
                                                    .removeAt(index1);
                                                setState(() {});
                                                print(
                                                    'controller.valueFinal ${controller.valueFinal}');
                                              },
                                              child: Icon(
                                                Icons.cancel,
                                                color: ColorUtils.kTint,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                        ),
                      );
                    },
                  ),
                  GetBuilder<GetTagsViewModel>(
                    builder: (controller) {
                      return Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.1,
                          ),
                          GetBuilder<AddForumViewModel>(
                            builder: (addForumViewModel) {
                              return GestureDetector(
                                onTap: () async {
                                  if (title.text.isEmpty) {
                                    Get.showSnackbar(GetSnackBar(
                                      duration: Duration(seconds: 2),
                                      messageText: Text(
                                        'Please add title......',
                                        style: FontTextStyle.kTine17BoldRoboto,
                                      ),
                                    ));
                                  } else if (description.text.isEmpty) {
                                    Get.showSnackbar(GetSnackBar(
                                      duration: Duration(seconds: 2),
                                      messageText: Text(
                                        'Please add description......',
                                        style: FontTextStyle.kTine17BoldRoboto,
                                      ),
                                    ));
                                  } else if (data.isEmpty) {
                                    Get.showSnackbar(GetSnackBar(
                                      duration: Duration(seconds: 2),
                                      messageText: Text(
                                        'Please elect tag......',
                                        style: FontTextStyle.kTine17BoldRoboto,
                                      ),
                                    ));
                                  } else {
                                    String data3 = '';
                                    var data1 = data.toString();

                                    var data2 =
                                        data1.substring(1, data1.length - 1);
                                    print('data1  ${data2}');
                                    AddForumRequestModel model =
                                        AddForumRequestModel();
                                    model.userId = PreferenceManager.getUId();
                                    model.tagId = data2;
                                    model.title = title.text;
                                    model.description = description.text;
                                    await addForumViewModel
                                        .addForumViewModel(model);
                                    if (addForumViewModel
                                            .addForumApiResponse.status ==
                                        Status.COMPLETE) {
                                      AddForumResponseModel responseModel =
                                          addForumViewModel
                                              .addForumApiResponse.data;
                                      if (responseModel.success == true) {
                                        Get.showSnackbar(GetSnackBar(
                                          duration: Duration(seconds: 2),
                                          messageText: Text(
                                            'Post created successfully....',
                                            style:
                                                FontTextStyle.kTine17BoldRoboto,
                                          ),
                                        ));
                                        Future.delayed(Duration(seconds: 2),
                                            () async {
                                          forumViewModel.selectedMenu =
                                              'All Posts'.obs;
                                          Navigator.pop(context);
                                          SearchForumRequestModel model =
                                              SearchForumRequestModel();
                                          model.title = '';
                                          model.userId =
                                              PreferenceManager.getUId();

                                          await forumViewModel
                                              .searchForumViewModel(model);
                                          if (forumViewModel
                                                  .searchApiResponse.status ==
                                              Status.COMPLETE) {
                                            GetAllForumsResponseModel response =
                                                forumViewModel
                                                    .searchApiResponse.data;

                                            forumViewModel
                                                .setLikeDisLike(response.data!);
                                          }

                                          controller.setSelectTagId('');

                                          title.clear();
                                          description.clear();
                                        });
                                      } else {
                                        Get.showSnackbar(GetSnackBar(
                                          duration: Duration(seconds: 2),
                                          messageText: Text(
                                            'Post not created',
                                            style:
                                                FontTextStyle.kTine17BoldRoboto,
                                          ),
                                        ));
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  height: Get.height * 0.05,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: ColorUtils.kTint,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      'Add Post',
                                      style: FontTextStyle.kBlack20BoldRoboto,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<AddForumViewModel>(
            builder: (addForumViewModel) {
              if (addForumViewModel.addForumApiResponse.status ==
                  Status.LOADING) {
                return Container(
                    color: Colors.white10,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: ColorUtils.kTint,
                    )));
              }
              return SizedBox();
            },
          )
        ],
      ),
    );
  }
}

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller, {Key? key}) : super(key: key);

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }
}
