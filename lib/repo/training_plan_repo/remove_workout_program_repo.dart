import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/remove_workout_program_response_model.dart';

class RemoveWorkoutProgramRepo extends ApiRoutes {
  Future<dynamic> removeWorkoutProgramRepo(Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: removeWorkoutProgramUrl, body: body);

    RemoveWorkoutProgramResponseModel removeWorkoutProgramResponseModel =
        RemoveWorkoutProgramResponseModel.fromJson(response);
    return removeWorkoutProgramResponseModel;
  }
}
