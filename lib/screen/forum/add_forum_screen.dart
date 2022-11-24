import 'dart:convert';
import 'dart:developer' as d;
import 'dart:io';
import 'dart:math';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/forum_request_model/add_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_forum_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forum_category_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forums_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/forum/video_preview_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/forum_viewModel/get_all_forum_category_viewmodel.dart';
import 'package:tcm/viewModel/forum_viewModel/get_category_tag_viewmodel.dart';
import 'package:tcm/viewModel/forum_viewModel/tags_viewModel.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import '../../api_services/api_routes.dart';
import '../../model/request_model/forum_request_model/search_forum_request_model.dart';
import '../../model/response_model/forum_response_model/get_tags_response_model.dart';
import '../../viewModel/forum_viewModel/add_forum_viewmodel.dart';
import '../../viewModel/forum_viewModel/forum_viewmodel.dart';
import 'compress_video_screen.dart';
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
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  ForumViewModel forumViewModel = Get.find();
  var keybardHeight = 0.0;
  List data = [];
  List<File> files = [];
  MediaInfo? mediaInfo;
  bool isLongVideo = false;
  bool isStartCompressing = false;
  ImagePicker _picker = ImagePicker();
  File? selectFile;

  List<Category> category = [];

  String? selectCategory;
  String? selectCategoryId;
  GetAllForumCategoryViewModel getAllForumCategoryViewModel =
      Get.put(GetAllForumCategoryViewModel());
  GetCategoryTagViewModel getCategoryTagViewModel =
      Get.put(GetCategoryTagViewModel());
  @override
  void initState() {
    // TODO: implement initState
    _connectivityCheckViewModel.startMonitoring();
    // getTagsViewModel.getTagsViewModel(title: '');
    getCategory();
  }

  getCategory() async {
    await getAllForumCategoryViewModel.getAllForumCategoryViewModel();
  }

  @override
  Widget build(BuildContext context) {
    print('LISt === ${addForumViewModel.filesAll}');
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
              VideoCompress.cancelCompression();
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addForumViewModel.filesAll.length >= 5
                            ? SizedBox()
                            : Padding(
                                padding:
                                    EdgeInsets.only(top: Get.height * 0.007),
                                child: GestureDetector(
                                  onTap: () async {
                                    // FilePickerResult? result =
                                    //     await FilePicker.platform.pickFiles(
                                    //         type: FileType.custom,
                                    //         allowCompression: true,
                                    //         allowedExtensions: [
                                    //       'jpg',
                                    //       'mp4',
                                    //       'png',
                                    //       'mov'
                                    //     ]);

                                    Get.dialog(Center(
                                      child: Container(
                                        height: Get.height * 0.2,
                                        width: Get.height * 0.25,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black,
                                            border: Border.all(
                                                color: ColorUtils.kTint)),
                                        child: Material(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              /// image
                                              GestureDetector(
                                                onTap: () async {
                                                  print('press....');
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
                                                    setState(() {
                                                      addForumViewModel.filesAll
                                                          .add({
                                                        'type': 'image',
                                                        'file':
                                                            File(image.path),
                                                        'thumbnail': image.path,
                                                        'size': 0,
                                                        'duration': 0,
                                                      });
                                                    });
                                                  }
                                                  Get.back();
                                                },
                                                child: Container(
                                                  height: Get.height * 0.055,
                                                  width: Get.width * 0.4,
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.kTint,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Image",
                                                      style: FontTextStyle
                                                          .kBlack20BoldRoboto,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              /// video
                                              GestureDetector(
                                                onTap: () async {
                                                  Get.back();
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
                                                        false,
                                                        ""));
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
                                                child: Container(
                                                  height: Get.height * 0.055,
                                                  width: Get.width * 0.4,
                                                  decoration: BoxDecoration(
                                                    color: ColorUtils.kTint,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Video",
                                                      style: FontTextStyle
                                                          .kBlack20BoldRoboto,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));

                                    // if (result != null) {
                                    //   d.log('filesfilesfiles  ${files}');
                                    //   files = result.paths
                                    //       .map((path) => File(path!))
                                    //       .toList();
                                    //
                                    //   files.forEach((element) async {
                                    //     setState(() {});
                                    //     if (element.path.isVideoFileName) {
                                    //       final uint8list = await VideoThumbnail
                                    //           .thumbnailData(
                                    //         video: element.path,
                                    //         imageFormat: ImageFormat.JPEG,
                                    //         maxHeight: 250,
                                    //         maxWidth: 250,
                                    //         quality: 50,
                                    //       );
                                    //       Uint8List imageInUnit8List =
                                    //           uint8list!; // store unit8List image here ;
                                    //       final tempDir =
                                    //           await getTemporaryDirectory();
                                    //       File file = await File(
                                    //               '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png')
                                    //           .create();
                                    //       file.writeAsBytesSync(
                                    //           imageInUnit8List);
                                    //
                                    //       var a = await videoInfo
                                    //           .getVideoInfo(element.path);
                                    //
                                    //       setState(() {
                                    //         filesAll.add({
                                    //           'type': 'mp4',
                                    //           'file': element,
                                    //           'thumbnail': file,
                                    //           'size': a!.filesize,
                                    //           'duration': a.duration,
                                    //         });
                                    //       });
                                    //     } else {
                                    //       filesAll.add({
                                    //         'type': 'image',
                                    //         'file': element,
                                    //         'thumbnail': element,
                                    //         'size': 0,
                                    //         'duration': 0,
                                    //       });
                                    //     }
                                    //     // 2,400,000
                                    //     print(
                                    //         'filesAll filesAll?????? ${filesAll}');
                                    //   });
                                    //
                                    //   print('files >>>>${files}');
                                    // } else {
                                    //   // User canceled the picker
                                    // }
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
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: ColorUtils.kTint,
                                                size: Get.height * 0.05,
                                              ),
                                              Text(
                                                'UPLOAD',
                                                style: FontTextStyle
                                                    .kTine17BoldRoboto,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        GetBuilder<AddForumViewModel>(
                          builder: (controller22) => Container(
                            height: Get.height * 0.15,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                  controller22.filesAll.length, (index) {
                                if (controller22.filesAll[index]['type'] ==
                                    'image') {
                                  print('hello....1');
                                  return Padding(
                                    padding: EdgeInsets.all(Get.height * 0.007),
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(ImagePreviewScreen(
                                              path: "",
                                              commentScreen: false,
                                              image: controller22
                                                  .filesAll[index]['file'],
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
                                                controller22.filesAll[index]
                                                    ['file'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: -Get.height * 0.007,
                                          right: -Get.height * 0.007,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                print(
                                                    'filesAll  ${controller22.filesAll}');
                                                controller22.filesAll
                                                    .removeAt(index);
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
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  controller22.filesAll.forEach((element) {
                                    if (controller22.filesAll[index]
                                            ['duration'] <=
                                        2400000.0) {
                                      isLongVideo = false;
                                    } else {
                                      isLongVideo = true;
                                    }
                                    print('ELEMENT>>>>>>>  $element');
                                  });
                                  print(
                                      'hello....2  ${addForumViewModel.filesAll[index]['duration']}');

                                  return Padding(
                                    padding: EdgeInsets.all(Get.height * 0.007),
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            Get.to(VideoPreviewScreen(
                                              video: addForumViewModel
                                                  .filesAll[index]['file'],
                                            ));
                                          },
                                          child: Container(
                                            height: Get.height * 0.12,
                                            width: Get.height * 0.12,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: (addForumViewModel
                                                                .filesAll[index]
                                                            ['duration'] <=
                                                        2400000.0)
                                                    ? Border.all(
                                                        color: ColorUtils.kTint)
                                                    : Border.all(
                                                        color:
                                                            ColorUtils.kRed)),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  addForumViewModel
                                                          .filesAll[index]
                                                      ['thumbnail'],
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                        (addForumViewModel.filesAll[index]
                                                    ['duration'] <=
                                                2400000.0)
                                            ? SizedBox()
                                            : Positioned(
                                                bottom: -15,
                                                left: 0,
                                                child: Text(
                                                  'Too large....',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize:
                                                          Get.height * 0.016),
                                                ),
                                              ),
                                        Positioned(
                                          top: -Get.height * 0.007,
                                          right: -Get.height * 0.007,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                print(
                                                    'filesAll  ${addForumViewModel.filesAll}');
                                                addForumViewModel.filesAll
                                                    .removeAt(index);
                                              });
                                            },
                                            child: CircleAvatar(
                                                radius: Get.height * 0.013,
                                                backgroundColor:
                                                    ColorUtils.kTint,
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
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Text(
                    'Category : ',
                    style: FontTextStyle.kGreyBoldRoboto,
                  ),
                  SizedBox(
                    height: Get.height * 0.012,
                  ),
                  GetBuilder<GetAllForumCategoryViewModel>(
                    builder: (contrller) {
                      if (contrller.apiResponse.status == Status.LOADING) {
                        return GestureDetector(
                          onTap: () {
                            Get.showSnackbar(
                              GetSnackBar(
                                duration: Duration(seconds: 2),
                                messageText: Text(
                                  'Category Loading...',
                                  style: FontTextStyle.kTine17BoldRoboto,
                                ),
                              ),
                            );
                          },
                          child: Container(
                              height: Get.height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                  colors: ColorUtilsGradient.kTintGradient,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Category",
                                        style: FontTextStyle.kBlack16BoldRoboto,
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.black,
                                      ),
                                    ]),
                              )),
                        );
                      } else {
                        GetAllForumCategoryResponseModel responseModel =
                            getAllForumCategoryViewModel.apiResponse.data;
                        /*getAllForumCategoryViewModel.allCategory.clear();
                        getAllForumCategoryViewModel.allCategoryId.clear();
                        for (int i = 0; i < responseModel.data!.length; i++) {
                          if (getAllForumCategoryViewModel.allCategory.contains(
                              responseModel.data![i].categoryTitle!.trim())) {
                            print('Enter in=====');
                          } else {
                            getAllForumCategoryViewModel.allCategory.add(
                                responseModel.data![i].categoryTitle!.trim());
                            getAllForumCategoryViewModel.allCategoryId
                                .add(responseModel.data![i].categoryId!.trim());
                          }
                        }
                        print(
                            'List of all category >>. ${getAllForumCategoryViewModel.allCategory}');
                        print(
                            'List of all category ID >>. ${getAllForumCategoryViewModel.allCategoryId}');
*/
                        return Container(
                          height: Get.height * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                              colors: ColorUtilsGradient.kTintGradient,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: DropdownButton(
                              items: responseModel.data!.map((item) {
                                return DropdownMenuItem<String>(
                                    child: Text(
                                      item.categoryTitle!,
                                      style: FontTextStyle.kBlack16BoldRoboto,
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        selectCategoryId = item.categoryId;
                                        print(
                                            'selected categoryId >>.. $selectCategoryId');
                                      });
                                      await getTagsViewModel.getTagsViewModel(
                                          title: '',
                                          categoryId: item.categoryId);
                                      getTagsViewModel.allTagTitle.clear();
                                      if (getTagsViewModel
                                              .getTagsApiResponse.status ==
                                          Status.COMPLETE) {
                                        GetTagsResponseModel response =
                                            getTagsViewModel
                                                .getTagsApiResponse.data;
                                        for (var i = 0;
                                            i < response.data!.length;
                                            i++) {
                                          getTagsViewModel.allTagTitle
                                              .add(response.data![i].title);
                                        }
                                        print(
                                            'AllTagTitle >>>>> ${getTagsViewModel.allTagTitle}');
                                      }
                                    },
                                    value: item.categoryTitle!);
                              }).toList(),
                              underline: SizedBox(),
                              isExpanded: false,
                              hint: Text(
                                "Category",
                                style: FontTextStyle.kBlack16BoldRoboto,
                              ),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  selectCategory = value!;
                                  print('item.categoryTitle>> $selectCategory');
                                });
                                print(
                                    'selected category of user >>.. $selectCategory');
                              },
                              value: selectCategory,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (selectCategoryId == null) {
                        Get.showSnackbar(GetSnackBar(
                          duration: Duration(seconds: 2),
                          messageText: Text(
                            'Please select category',
                            style: FontTextStyle.kTine17BoldRoboto,
                          ),
                        ));
                      } else {
                        await getTagsViewModel.getTagsViewModel(
                            title: '', categoryId: selectCategoryId);
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
                                                  FocusScope.of(context)
                                                      .unfocus();
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
                                                      .selectedTagTitle
                                                      .isEmpty) {
                                                    Navigator.pop(context);

                                                    controller
                                                        .setSelectTagId('');
                                                    controller
                                                        .setSelectedTagTitle(
                                                            '');
                                                  } else {
                                                    controller.valueFinal.add({
                                                      'id': controller
                                                          .selectTagId,
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
                                                        jsonList
                                                            .toSet()
                                                            .toList();

                                                    // convert each item back to the original form using JSON decoding
                                                    final result =
                                                        uniqueJsonList
                                                            .map((item) =>
                                                                jsonDecode(
                                                                    item))
                                                            .toList();

                                                    controller
                                                        .setValueFinal(result);
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    Navigator.pop(context);

                                                    controller
                                                        .setSelectTagId('');
                                                    controller
                                                        .setSelectedTagTitle(
                                                            '');
                                                  }
                                                } else {
                                                  Get.back();
                                                  FocusScope.of(context)
                                                      .unfocus();
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
                                                .getTagsViewModel(
                                                    title: val,
                                                    categoryId:
                                                        selectCategoryId);
                                          },
                                          fullwidth: false,
                                          onSubmitted: (val) async {
                                            if (tag.text.isNotEmpty) {
                                              if (controller
                                                  .selectedTagTitle.isEmpty) {
                                                Navigator.pop(context);
                                                FocusScope.of(context)
                                                    .unfocus();
                                                controller.setSelectTagId('');
                                                controller
                                                    .setSelectedTagTitle('');
                                              } else {
                                                controller.valueFinal.add({
                                                  'id': controller.selectTagId,
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
                                                FocusScope.of(context)
                                                    .unfocus();
                                                controller.setSelectTagId('');
                                                controller
                                                    .setSelectedTagTitle('');
                                              }
                                            } else {
                                              Get.back();
                                              FocusScope.of(context).unfocus();
                                              controller.setSelectTagId('');
                                              controller
                                                  .setSelectedTagTitle('');
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
                                              decorationColor: Colors.white
                                                  .withOpacity(0.01)),
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical:
                                                        Get.height * 0.007,
                                                    horizontal:
                                                        Get.height * 0.01),
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
                                                          response
                                                              .data![index].id
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
                                                                  offset: tag
                                                                      .text
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
                                                        padding: EdgeInsets
                                                            .symmetric(
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
                      }
                    },
                    child: Container(
                      height: Get.height * 0.05,
                      width: Get.width * 0.365,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          colors: ColorUtilsGradient.kTintGradient,
                        ),
                      ),
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
                          children: List.generate(controller.valueFinal.length,
                              (index1) {
                            if (controller.allTagTitle.contains(
                                controller.valueFinal[index1]['title'])) {
                              return Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Container(
                                  height: Get.height * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: ColorUtils.kTint)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.height * 0.02),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${controller.valueFinal[index1]['title']}',
                                          style:
                                              FontTextStyle.kTint20BoldRoboto,
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
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                        ),
                      );
                    },
                  ),
                  GetBuilder<GetCategoryTagViewModel>(
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
                                  FocusScope.of(context).unfocus();
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
                                  } else if (isLongVideo == true) {
                                    Get.showSnackbar(GetSnackBar(
                                      duration: Duration(seconds: 2),
                                      messageText: Text(
                                        'Please select less than 40 min video',
                                        style: FontTextStyle.kTine17BoldRoboto,
                                      ),
                                    ));
                                  } else if (data.isEmpty) {
                                    Get.showSnackbar(GetSnackBar(
                                      duration: Duration(seconds: 2),
                                      messageText: Text(
                                        'Please select tag......',
                                        style: FontTextStyle.kTine17BoldRoboto,
                                      ),
                                    ));
                                  } else if (addForumViewModel
                                      .filesAll.isEmpty) {
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
                                    setState(() {
                                      isStartCompressing = true;
                                    });
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
                                          setState(() {
                                            isStartCompressing = false;
                                          });

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
                                  } else {
                                    for (int i = 0;
                                        i < addForumViewModel.filesAll.length;
                                        i++) {
                                      setState(() {
                                        isStartCompressing = true;
                                      });
                                      d.log('${addForumViewModel.filesAll}');
                                      if (addForumViewModel.filesAll[i]
                                              ['type'] ==
                                          'mp4') {
                                        d.log(
                                            'element>>>>>>....${addForumViewModel.filesAll[i]['file'].path}');

                                        print('MEdia Info >>> $mediaInfo');
                                        addForumViewModel.filesAll[i]['file'] =
                                            addForumViewModel.filesAll[i]
                                                ['file'];
                                      }

                                      if (addForumViewModel.filesAll[i] ==
                                          addForumViewModel.filesAll.last) {
                                        d.log(
                                            'filesAll??????>>>>>${addForumViewModel.filesAll}');

                                        d.log('finish.....>>>>>');

                                        var data1 = data.toString();

                                        var data2 = data1.substring(
                                            1, data1.length - 1);
                                        print('data1  ${data2}');

                                        List<dio.MultipartFile>? dataFile = [];
                                        for (int i = 0;
                                            i <
                                                addForumViewModel
                                                    .filesAll.length;
                                            i++) {
                                          print(
                                              'Fileeee  >>> ${addForumViewModel.filesAll[i]['file'].runtimeType}');
                                          dataFile.add(await dio.MultipartFile.fromFile(
                                              addForumViewModel
                                                  .filesAll[i]['file'].path,
                                              filename: addForumViewModel
                                                              .filesAll[i]
                                                          ['type'] ==
                                                      'mp4'
                                                  ? 'Video_${DateTime.now().millisecondsSinceEpoch}.mp4'
                                                  : 'Image_${DateTime.now().millisecondsSinceEpoch}.jpg'));

                                          d.log(
                                              'dataFiledataFiledataFile>>>>>>  ${dataFile}');
                                        }
                                        print(
                                            'selected category id>>> $selectCategoryId');
                                        Map<String, dynamic> body = {
                                          'title': title.text,
                                          'description': description.text,
                                          'tag_id': data2,
                                          'user_id': PreferenceManager.getUId(),
                                          'post_images[]': await dataFile,
                                          'caregory': selectCategoryId,
                                        };

                                        d.log(
                                            '>>>>>>>>>>>>>>>>>>>>>>>>??? ${body}');

                                        Map<String, String> header = {
                                          'content-type': 'application/json'
                                        };

                                        dio.FormData formData =
                                            dio.FormData.fromMap(body);

                                        dio.Response result = await dio.Dio()
                                            .post(ApiRoutes().addForumUrl,
                                                data: formData,
                                                options: dio.Options(
                                                    headers: header));
                                        setState(() {
                                          isStartCompressing = false;
                                        });

                                        AddForumResponseModel responseModel =
                                            AddForumResponseModel.fromJson(
                                                result.data);
                                        d.log(
                                            'resultresultresultresult>>>>>>${responseModel.success}');

                                        if (responseModel.success == true) {
                                          Get.showSnackbar(GetSnackBar(
                                            duration: Duration(seconds: 2),
                                            messageText: Text(
                                              'Post created successfully....',
                                              style: FontTextStyle
                                                  .kTine17BoldRoboto,
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
                                              GetAllForumsResponseModel
                                                  response = forumViewModel
                                                      .searchApiResponse.data;

                                              forumViewModel.setLikeDisLike(
                                                  response.data!);
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
                                              style: FontTextStyle
                                                  .kTine17BoldRoboto,
                                            ),
                                          ));
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  height: Get.height * 0.05,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.0, 1.0],
                                        colors:
                                            ColorUtilsGradient.kTintGradient,
                                      ),
                                      borderRadius: BorderRadius.circular(6)),
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
          isStartCompressing == true
              ? Container(
                  color: Colors.white10,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: ColorUtils.kTint,
                  )))
              : SizedBox(),
          /* GetBuilder<AddForumViewModel>(
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
          ),
          GetBuilder<GetAllForumCategoryViewModel>(
            builder: (contrller) {
              if (contrller.apiResponse.status == Status.LOADING) {
                return Container(
                    color: Colors.white10,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: ColorUtils.kTint,
                    )));
              }
              return SizedBox();
            },
          )*/
        ],
      ),
    );
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
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
