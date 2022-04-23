import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';

import '../model/response_model/all_workout_res_model.dart';
import '../repo/all_workout_repo.dart';

class AllWorkoutViewModel extends GetxController {
  // onInit() {
  //   boolCheckMap = true;
  //   print('-----------boolCheckMap---------${boolCheckMap}');
  // }
  //
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getPackageDetails() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      AllWorkOutResponseModel response =
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
