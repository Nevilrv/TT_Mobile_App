import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/check_workout_program_response_model.dart';

class CheckWorkoutProgramRepo extends ApiRoutes {
  Future<dynamic> checkWorkoutProgramRepo(Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: checkWorkoutProgramUrl, body: body);

    CheckWorkoutProgramResponseModel checkWorkoutProgramResponseModel =
        CheckWorkoutProgramResponseModel.fromJson(response);
    return checkWorkoutProgramResponseModel;
  }
}
