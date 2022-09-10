import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/all_workout_response_model.dart';

class AllWorkoutRepo extends ApiRoutes {
  Future<dynamic> allWorkoutRepo() async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: allWorkoutsUrl);

    AllWorkoutResponseModel allWorkOutResponseModel =
        AllWorkoutResponseModel.fromJson(response);
    return allWorkOutResponseModel;
  }
}

class AllWorkoutByIdRepo extends ApiRoutes {
  Future<dynamic> allWorkoutByIdRepo({String? id}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: allWorkoutsUrl + id!);

    AllWorkoutResponseModel allWorkOutResponseModel =
        AllWorkoutResponseModel.fromJson(response);
    return allWorkOutResponseModel;
  }
}
