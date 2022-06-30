import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/save_user_customized_exercise_response_model.dart';

class SaveUserCustomizedExerciseRepo extends ApiRoutes {
  Future<dynamic> saveUserCustomizedExerciseRepo(
      Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: saveUserCustomizedExerciseUrl, body: body);

    SaveUserCustomizedExerciseResponseModel
        saveUserCustomizedExerciseResponseModel =
        SaveUserCustomizedExerciseResponseModel.fromJson(response);
    return saveUserCustomizedExerciseResponseModel;
  }
}
