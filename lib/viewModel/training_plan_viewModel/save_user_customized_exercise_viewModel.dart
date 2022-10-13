import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/training_plan_request_model/save_user_customized_exercise_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/save_user_customized_exercise_response_model.dart';
import 'package:tcm/repo/training_plan_repo/save_user_customized_exercise_repo.dart';

class SaveUserCustomizedExerciseViewModel extends GetxController {
  int counterReps = 0;

  counterPlus({int? totCount}) {
    if (counterReps < totCount!) counterReps++;
    update();
  }

  counterMinus() {
    if (counterReps > 0) counterReps--;
    update();
  }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late SaveUserCustomizedExerciseResponseModel response;
  Future<void> saveUserCustomizedExerciseViewModel(
      SaveUserCustomizedExerciseRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('==SaveUserCustomizedExerciseViewModel=>');
      response = await SaveUserCustomizedExerciseRepo()
          .saveUserCustomizedExerciseRepo(model.toJson());
      print('==SaveUserCustomizedExerciseViewModel=>$response');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print("......... SaveUserCustomizedExerciseViewModel ===== $e");
    }
    update();
  }
}
