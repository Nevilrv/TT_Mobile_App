import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/exp_res_model.dart';
import 'package:tcm/repo/exp_repo.dart';

class ExperienceViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;

  Future<void> getExperienceLevel() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      ExperienceLevelResModel response =
          await ExperienceRepo().experienceRepo();
      _apiResponse = ApiResponse.complete(response);
    } catch (error) {
      print(".........>$error");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
