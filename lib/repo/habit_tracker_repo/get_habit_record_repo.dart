import 'dart:convert';

import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/habit_tracker_model/get_habit_record_date_response_model.dart';

class GetHabitRecordDateRepo extends ApiRoutes {
  Future<dynamic> getHabitRecordDateRepo(Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: getHabitRecordDateUrl, body: body);

    print('response ----------- $response');

    GetHabitRecordDateResponseModel getHabitRecordDateResponseModel =
        GetHabitRecordDateResponseModel.fromJson(response);
    return getHabitRecordDateResponseModel;
  }
}
