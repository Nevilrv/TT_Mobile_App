import 'dart:convert';

import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/forum_response_model/get_tags_response_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/get_habit_record_date_response_model.dart';

class GetTagsRepo extends ApiRoutes {
  Future<dynamic> getTagsRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: getTagsUrl);

    print('getTagsResponseModel ----------- $response');

    GetTagsResponseModel getTagsResponseModel =
        GetTagsResponseModel.fromJson(response);
    return getTagsResponseModel;
  }
}
