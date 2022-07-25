import 'dart:convert';

import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/request_model/forum_request_model/all_forum_request_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forums_response_model.dart';
import 'package:tcm/model/response_model/forum_response_model/get_tags_response_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/get_habit_record_date_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';

class GetAllForumsRepo extends ApiRoutes {
  Future<dynamic> getAllForumsRepo({String? filter}) async {
    String url =
        '${getAllForumsUrl}?filter=$filter&user_id=${PreferenceManager.getUId()}';

    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: url);

    print('getAllForumsResponseModel ----------- $response');

    GetAllForumsResponseModel getAllForumsResponseModel =
        GetAllForumsResponseModel.fromJson(response);
    return getAllForumsResponseModel;
  }
}
