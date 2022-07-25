import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/forum_request_model/add_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_forum_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forums_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_tags_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/forum_viewModel/tags_viewModel.dart';

import '../../model/request_model/forum_request_model/search_forum_request_model.dart';
import '../../viewModel/forum_viewModel/add_forum_viewmodel.dart';
import '../../viewModel/forum_viewModel/forum_viewmodel.dart';

class AddForumScreen extends StatefulWidget {
  const AddForumScreen({Key? key}) : super(key: key);

  @override
  _AddForumScreenState createState() => _AddForumScreenState();
}

class _AddForumScreenState extends State<AddForumScreen> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  GetTagsViewModel getTagsViewModel = Get.put(GetTagsViewModel());

  AddForumViewModel addForumViewModel = Get.put(AddForumViewModel());
  ForumViewModel forumViewModel = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    getTagsViewModel.getTagsViewModel();
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
                  Text(
                    'Select Tags : ',
                    style: FontTextStyle.kGreyBoldRoboto,
                  ),
                  SizedBox(
                    height: Get.height * 0.012,
                  ),
                  GetBuilder<GetTagsViewModel>(
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
                          Container(
                            width: Get.width,
                            height: Get.height * 0.05,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: response.data!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.setSelectTagId(response
                                            .data![index].tagId
                                            .toString());
                                      },
                                      child: Container(
                                        height: Get.height * 0.05,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: controller.selectTagId ==
                                                    response.data![index].tagId
                                                ? ColorUtils.kTint
                                                    .withOpacity(0.8)
                                                : ColorUtils.kBlack,
                                            border: Border.all(
                                                color: ColorUtils.kTint)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Get.height * 0.02),
                                          child: Center(
                                            child: Text(
                                              '#${response.data![index].tagTitle!}',
                                              style: controller.selectTagId ==
                                                      response
                                                          .data![index].tagId
                                                  ? FontTextStyle
                                                      .kBlack16BoldRoboto
                                                  : FontTextStyle
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
                                  } else if (controller.selectTagId == '') {
                                    Get.showSnackbar(GetSnackBar(
                                      duration: Duration(seconds: 2),
                                      messageText: Text(
                                        'Please elect tag......',
                                        style: FontTextStyle.kTine17BoldRoboto,
                                      ),
                                    ));
                                  } else {
                                    AddForumRequestModel model =
                                        AddForumRequestModel();
                                    model.userId = PreferenceManager.getUId();
                                    model.tagId = controller.selectTagId;
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
