import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/day_based_exercise_response_model.dart';

class DayBasedExerciseRepo extends ApiRoutes {
  Future<dynamic> dayBasedExerciseRepo({String? day, String? id}) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aGet, url: dayBaseWorkoutUrl + day! + "&id=" + id!);

    DayBasedExerciseResponseModel dayBasedExerciseResponseModel =
        DayBasedExerciseResponseModel.fromJson(response);
    return dayBasedExerciseResponseModel;
  }
}
