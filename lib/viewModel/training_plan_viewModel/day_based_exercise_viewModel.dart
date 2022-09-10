import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/day_based_exercise_response_model.dart';
import 'package:tcm/repo/training_plan_repo/day_based_exercise_repo.dart';

class DayBasedExerciseViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getDayBasedExerciseDetails({String? day, String? id}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      DayBasedExerciseResponseModel response =
          await DayBasedExerciseRepo().dayBasedExerciseRepo(id: id, day: day);
      print('DayBasedWorkoutModel=> $response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("DayBasedWorkoutModel => $e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
