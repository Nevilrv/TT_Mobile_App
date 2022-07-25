import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/request_model/forum_request_model/add_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_forum_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/delete_forum_response_model.dart';

class DeleteForumRepo extends ApiRoutes {
  Future<dynamic> deleteForumRepo(String postId) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: deleteForum, body: {'id': postId});
    DeleteForumResponseModel deleteForumResponseModel =
        DeleteForumResponseModel.fromJson(response);
    return deleteForumResponseModel;
  }
}
