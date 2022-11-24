import 'dart:convert';

import 'package:get/get.dart';
import 'package:tcm/model/request_model/forum_request_model/add_comments_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/dislike_forum_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/like_forum_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/search_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_comment_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/delete_forum_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_comments_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/like_dislike_respone_model.dart';
import 'package:tcm/repo/forum_repo/add_comment_repo.dart';
import 'package:tcm/repo/forum_repo/add_forum_repo.dart';
import 'package:tcm/repo/forum_repo/delete_forum_repo.dart';
import 'package:tcm/repo/forum_repo/get_all_comments_repo.dart';
import 'package:tcm/repo/forum_repo/like_dislike_repo.dart';

import '../../api_services/api_response.dart';
import '../../model/request_model/forum_request_model/add_forum_request_model.dart';
import '../../model/response_model/forum_response_model/add_forum_response_model.dart';
import '../../model/response_model/forum_response_model/get_all_forums_response_model.dart'
    as all;
import '../../model/response_model/forum_response_model/report_response_model.dart';
import '../../repo/forum_repo/delete_comment_repo.dart';
import '../../repo/forum_repo/get_all_forums_repo.dart';
import '../../repo/forum_repo/report_Forum_repo.dart';
import '../../repo/forum_repo/search_forum_repo.dart';

class ForumViewModel extends GetxController {
  int _totalLike = 0;
  int get totalLike => _totalLike;
  void setTotalLike(int value) {
    _totalLike = value;
    update();
  }

  String allPost = '';
  void setAllPost(String value) {
    allPost = value;
    update();
  }

  List<all.Datum> _likeDisLike = <all.Datum>[];

  List<all.Datum> get likeDisLike => _likeDisLike;

  void setLikeDisLike(List<all.Datum> value) {
    _likeDisLike = value;
  }

  RxString _selectedMenu = 'All Posts'.obs;

  RxString get selectedMenu => _selectedMenu;

  set selectedMenu(RxString value) {
    _selectedMenu.value = value.value;
  }

  ApiResponse _getAllForumsApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getAllForumsApiResponse => _getAllForumsApiResponse;
  late all.GetAllForumsResponseModel getAllForumsResponseModel;
  Future<void> getAllForumsViewModel({String? filter}) async {
    if (_getAllForumsApiResponse.status == Status.INITIAL) {
      _getAllForumsApiResponse = ApiResponse.loading(message: 'Loading');
    }

    update();

    try {
      print('==getAllForumsResponseModel=>');
      getAllForumsResponseModel =
          await GetAllForumsRepo().getAllForumsRepo(filter: filter);
      print('==getAllForumsResponseModel=>$_getAllForumsApiResponse');

      _getAllForumsApiResponse =
          ApiResponse.complete(getAllForumsResponseModel);
    } catch (e) {
      _getAllForumsApiResponse = ApiResponse.error(message: e.toString());
      print("......... getAllForumsResponseModel ===== $e");
    }
    update();
  }

  ApiResponse _searchApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get searchApiResponse => _searchApiResponse;
  Future<void> searchForumViewModel(SearchForumRequestModel model) async {
    if (_searchApiResponse.status == Status.INITIAL) {
      _searchApiResponse = ApiResponse.loading(message: 'Loading');
    }

    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('==_searchApiResponse=>');
      all.GetAllForumsResponseModel response =
          await SearchForumRepo().searchForumRepo(model);
      print('==_searchApiResponse=>$response');

      _searchApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _searchApiResponse = ApiResponse.error(message: e.toString());
      print("......... _searchApiResponse ===== $e");
    }
    update();
  }

  ApiResponse _deleteForumApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get deleteForumApiResponse => _deleteForumApiResponse;
  Future<void> deleteForumViewModel(String id) async {
    _deleteForumApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      DeleteForumResponseModel response =
          await DeleteForumRepo().deleteForumRepo(id);
      print('==_deleteForumApiResponse=>$response');
      _deleteForumApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _deleteForumApiResponse = ApiResponse.error(message: e.toString());
      print("......... _deleteForumApiResponse ===== $e");
    }
    update();
  }

  ApiResponse _reportForumApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get reportForumApiResponse => _reportForumApiResponse;
  Future<void> reportForumViewModel(String id) async {
    _reportForumApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      ReportForumResponseModel response =
          await ReportForumRepo().reportForumRepo(postId: id);
      print('==_reportForumApiResponse=>$response');
      _reportForumApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _reportForumApiResponse = ApiResponse.error(message: e.toString());
      print("......... _reportForumApiResponse ===== $e");
    }
    update();
  }

  ApiResponse _deleteCommentApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get deleteCommentApiResponse => _deleteCommentApiResponse;
  Future<void> deleteCommentViewModel(
      {String? commentId, String? userId}) async {
    _deleteCommentApiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      DeleteForumResponseModel response = await DeleteCommentRepo()
          .deleteCommentRepo(commentId: commentId, userId: userId);
      print('==_deleteCommentApiResponse=>$response');
      _deleteCommentApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _deleteCommentApiResponse = ApiResponse.error(message: e.toString());
      print("......... _deleteCommentApiResponse ===== $e");
    }
    update();
  }

  ApiResponse _likeForumApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get likeForumApiResponse => _likeForumApiResponse;

  Future<void> likeForumViewModel(LikeForumRequestModel model) async {
    _likeForumApiResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      LikeDisLikeResponseModel response =
          await LikeDislikeRepo().likeRepo(model);
      print('==_likeForumApiResponse=>$response');

      _likeForumApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _likeForumApiResponse = ApiResponse.error(message: e.toString());
      print("......... _likeForumApiResponse ===== $e");
    }
    update();
  }

  ApiResponse _disLikeForumApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get disLikeForumApiResponse => _disLikeForumApiResponse;
  Future<void> disLikeForumViewModel(DisLikeForumRequestModel model) async {
    _disLikeForumApiResponse = ApiResponse.loading(message: 'Loading');
    update();

    try {
      LikeDisLikeResponseModel response =
          await LikeDislikeRepo().disLikeRepo(model);
      print('==_disLikeForumApiResponse=>$response');

      _disLikeForumApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _disLikeForumApiResponse = ApiResponse.error(message: e.toString());
      print("......... _disLikeForumApiResponse ===== $e");
    }
    update();
  }
}
