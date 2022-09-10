import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/save_workout_program_response_model.dart';

class SaveWorkoutProgramRepo extends ApiRoutes {
  Future<dynamic> saveWorkoutProgramRepo(Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: saveWorkoutProgramUrl, body: body);

    SaveWorkoutProgramResponseModel saveWorkoutProgramResponseModel =
        SaveWorkoutProgramResponseModel.fromJson(response);
    return saveWorkoutProgramResponseModel;
  }
}
