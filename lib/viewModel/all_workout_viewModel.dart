import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/all_workout_response_model.dart';
import 'package:tcm/repo/training_plan_repo/all_workout_repo.dart';

class AllWorkoutViewModel extends GetxController {
  // onInit() {
  //   boolCheckMap = true;
  //   print('-----------boolCheckMap---------${boolCheckMap}');
  // }
  //

  String? gender;
  String? goal;
  String? duration;

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getWorkoutDetails() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      AllWorkoutResponseModel response =
          await AllWorkoutRepo().allWorkoutRepo();
      print('AllWorkOutResponseModel=>${response}');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print(".........>$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}

class AllWorkoutByIdViewModel extends GetxController {
  // onInit() {
  //   boolCheckMap = true;
  //   print('-----------boolCheckMap---------${boolCheckMap}');
  // }
  //
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getWorkoutByIdDetails({String? id}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      AllWorkoutResponseModel response =
          await AllWorkoutByIdRepo().allWorkoutByIdRepo(id: id);
      print('AllWorkOutResponseModel=>${response}');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print(".........>$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
