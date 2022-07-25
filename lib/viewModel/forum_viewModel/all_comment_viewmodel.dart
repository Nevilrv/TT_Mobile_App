import 'dart:convert';

import 'package:get/get.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_comments_response_model.dart';

import 'package:tcm/repo/forum_repo/get_all_comments_repo.dart';

import '../../api_services/api_response.dart';
import '../../model/request_model/forum_request_model/add_comments_request_model.dart';
import '../../model/response_model/forum_response_model/add_comment_response_model.dart';
import '../../repo/forum_repo/add_comment_repo.dart';

class AllCommentViewModel extends GetxController {
  ApiResponse _getAllCommentsApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getAllCommentsApiResponse => _getAllCommentsApiResponse;
  Future<void> getAllCommentsViewModel({String? postId}) async {
    if (_getAllCommentsApiResponse.status == Status.INITIAL) {
      _getAllCommentsApiResponse = ApiResponse.loading(message: 'Loading');
      update();
    }
    // update();

    try {
      print('==_getAllCommentsApiResponse=>');
      GetAllCommentsResponseModel responseModel =
          await GetAllCommentsRepo().getAllCommentsRepo(postId: postId);

      print('==_getAllCommentsApiResponse=>$responseModel');

      _getAllCommentsApiResponse = ApiResponse.complete(responseModel);
    } catch (e) {
      _getAllCommentsApiResponse = ApiResponse.error(message: e.toString());
      print("......... getAllForumsResponseModel ===== $e");
    }
    update();
  }

  ApiResponse _addCommentApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get addCommentApiResponse => _addCommentApiResponse;

  Future<void> addCommentsViewModel(AddCommentRequestModel model) async {
    _addCommentApiResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      print('==_addCommentApiResponse=>');
      AddCommentResponseModel response =
          await AddCommentRepo().addCommentRepo(model);
      print('==_addCommentApiResponse=>$response');

      _addCommentApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _addCommentApiResponse = ApiResponse.error(message: e.toString());
      print("......... _addCommentApiResponse ===== $e");
    }
    update();
  }
}
