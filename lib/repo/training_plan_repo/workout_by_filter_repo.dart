import 'dart:developer';

import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_filter_response_model.dart';

class WorkoutByFilterRepo extends ApiRoutes {
  Future<dynamic> workoutByFilterRepo(
      {String? goal, String? duration, String? gender, String? userId}) async {
    log("repo $workoutByFilterUrl");
    var response = await ApiService().getResponse(
        apiType: APIType.aGet,
        url: workoutByFilterUrl +
            goal! +
            "&duration=" +
            duration! +
            "&gender=" +
            gender! +
            "&user_id=" +
            userId!);
    log("responseresponseresponse $response");
    WorkoutByFilterResponseModel workoutByFilterResponseModel =
        WorkoutByFilterResponseModel.fromJson(response);
    return workoutByFilterResponseModel;
  }
}
