import 'dart:convert';

import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/habit_tracker_model/get_habit_record_response_model.dart';

class GetHabitRecordRepo extends ApiRoutes {
  Future<dynamic> getHabitRecordRepo(Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: getHabitRecordurl, body: body);

    print('response ----------- $response');

    GetHabitRecordResponseModel getHabitRecordResponseModel =
        GetHabitRecordResponseModel.fromJson(response);
    return getHabitRecordResponseModel;
  }
}
