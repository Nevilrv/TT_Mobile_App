import 'dart:developer';

import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/workout_response_model/user_workouts_date_response_model.dart';

class UserWorkoutsDateRepo extends ApiRoutes {
  Future<UserWorkoutsDateResponseModel> userWorkoutsDateRepo(
      {String? userId, String? date}) async {
    log("repo $userId");
    var response = await ApiService().getResponse(
        apiType: APIType.aGet,
        url: userWorkoutsDateUrl + userId! + "&date=" + date!);
    print('response>>>>> $response');
    UserWorkoutsDateResponseModel userWorkoutsDateResponseModel =
        UserWorkoutsDateResponseModel.fromJson(response);
    return userWorkoutsDateResponseModel;
  }
}
