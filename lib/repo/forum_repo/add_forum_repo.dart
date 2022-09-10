import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/request_model/forum_request_model/add_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_forum_response_model.dart';

class AddForumRepo extends ApiRoutes {
  Future<dynamic> addForumRepo(AddForumRequestModel body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: addForumUrl, body: body.toJson());

    AddForumResponseModel addForumResponseModel =
        AddForumResponseModel.fromJson(response);
    return addForumResponseModel;
  }
}
