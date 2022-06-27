import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/repo/training_plan_repo/workout_by_id_repo.dart';

class WorkoutByIdViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getWorkoutByIdDetails({String? id}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      WorkoutByIdResponseModel response =
          await WorkoutByIdRepo().workoutByIdRepo(id: id);
      print('workout by id try ====> $response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("workout by id catch ====>$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }

  bool isCallOneTime = true;
  List<String> dayAddedList = [];
  setDayAddedList({required String value}) {
    dayAddedList.add(value);
    update();
  }

  setAndRemove({required String keyValue}) {
    if (dayAddedList.contains(keyValue)) {
      dayAddedList.remove(keyValue);
    } else {
      dayAddedList.add(keyValue);
    }
    print('controller call -------');
    update();
  }
}
