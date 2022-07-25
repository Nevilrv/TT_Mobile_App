import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/request_model/forum_request_model/add_comments_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/add_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_comment_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_forum_response_model.dart';

class AddCommentRepo extends ApiRoutes {
  Future<dynamic> addCommentRepo(AddCommentRequestModel body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: addCommentUrl, body: body.toJson());

    AddCommentResponseModel addCommentResponseModel =
        AddCommentResponseModel.fromJson(response);
    return addCommentResponseModel;
  }
}
