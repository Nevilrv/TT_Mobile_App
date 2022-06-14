import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_filter_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';

class WorkoutByIdRepo extends ApiRoutes {
  Future<dynamic> workoutByIdRepo({String? id}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: workoutByID + id!);

    WorkoutByIdResponseModel workoutByIdResponseModel =
        WorkoutByIdResponseModel.fromJson(response);
    return workoutByIdResponseModel;
  }
}
