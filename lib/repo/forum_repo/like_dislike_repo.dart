import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/request_model/forum_request_model/add_comments_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/add_forum_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/dislike_forum_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/like_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_comment_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_forum_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/like_dislike_respone_model.dart';

class LikeDislikeRepo extends ApiRoutes {
  Future<dynamic> likeRepo(LikeForumRequestModel body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: likeForum, body: body.toJson());

    LikeDisLikeResponseModel likeDisLikeResponseModel =
        LikeDisLikeResponseModel.fromJson(response);
    return likeDisLikeResponseModel;
  }

  Future<dynamic> disLikeRepo(DisLikeForumRequestModel body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: disLikeForum, body: body.toJson());

    LikeDisLikeResponseModel likeDisLikeResponseModel =
        LikeDisLikeResponseModel.fromJson(response);
    return likeDisLikeResponseModel;
  }
}
