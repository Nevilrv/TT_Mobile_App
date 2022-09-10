import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/all_bodyparts_response_model.dart';
import 'package:tcm/repo/training_plan_repo/all_bodyparts_repo.dart';

class AllBodyPartsViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;

  Future<void> getBodyPartsDetails() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      BodyPartsResponseModel response =
          await AllBodyPartsRepo().allBodyPartsRepo();
      _apiResponse = ApiResponse.complete(response);
    } catch (error) {
      print(".........>$error");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
