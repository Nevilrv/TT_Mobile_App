import 'dart:convert';

import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_comments_response_model.dart';

import 'package:tcm/repo/forum_repo/get_all_comments_repo.dart';

import '../../api_services/api_response.dart';
import '../../model/request_model/forum_request_model/add_comments_request_model.dart';
import '../../model/request_model/forum_request_model/add_forum_request_model.dart';
import '../../model/response_model/forum_response_model/add_comment_response_model.dart';
import '../../model/response_model/forum_response_model/add_forum_response_model.dart';
import '../../repo/forum_repo/add_comment_repo.dart';
import '../../repo/forum_repo/add_forum_repo.dart';

class AddForumViewModel extends GetxController {
  FlutterVideoInfo videoInfo = FlutterVideoInfo();
  List<Map<String, dynamic>> filesAll = [];

  dataAddInFileAll(file, thumbnailFile, fileSize, duration) {
    filesAll.add({
      'type': 'mp4',
      'file': file,
      'thumbnail': thumbnailFile,
      'size': fileSize,
      'duration': duration,
    });

    update();
  }

  ApiResponse _addForumApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get addForumApiResponse => _addForumApiResponse;
  late AddForumResponseModel response;

  Future<void> addForumViewModel(AddForumRequestModel model) async {
    _addForumApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('==AddUserHabitIdViewModel=>');
      response = await AddForumRepo().addForumRepo(model);
      print('==_addForumApiResponse=>$response');

      _addForumApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _addForumApiResponse = ApiResponse.error(message: e.toString());
      print("......... _addForumApiResponse ===== $e");
    }
    update();
  }
}
