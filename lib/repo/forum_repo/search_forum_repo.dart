import 'package:tcm/model/request_model/forum_request_model/search_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forums_response_model.dart';

import '../../api_services/api_routes.dart';

import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/request_model/forum_request_model/add_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_forum_response_model.dart';

class SearchForumRepo extends ApiRoutes {
  Future<dynamic> searchForumRepo(SearchForumRequestModel body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: searchUrl, body: body.toJson());

    GetAllForumsResponseModel getAllForumsResponseModel =
        GetAllForumsResponseModel.fromJson(response);
    return getAllForumsResponseModel;
  }
}
