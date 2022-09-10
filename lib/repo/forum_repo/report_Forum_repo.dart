import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/request_model/forum_request_model/add_comments_request_model.dart';
import 'package:tcm/model/request_model/forum_request_model/add_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_comment_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/add_forum_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';

import '../../model/response_model/forum_response_model/report_response_model.dart';

class ReportForumRepo extends ApiRoutes {
  Future<dynamic> reportForumRepo({String? postId}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: reportFourm, body: {
      'post_id': postId,
      'user_id': PreferenceManager.getUId(),
    });

    ReportForumResponseModel reportForumResponseModel =
        ReportForumResponseModel.fromJson(response);
    return reportForumResponseModel;
  }
}
