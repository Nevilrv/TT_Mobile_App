import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/all_categories_response_model.dart';
import 'package:tcm/repo/training_plan_repo/all_categories_repo.dart';

class AllCategoriesViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;

  Future<void> getCategoriesDetails() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      CategoriesResponseModel response =
          await AllCategoriesRepo().allCategoriesRepo();
      _apiResponse = ApiResponse.complete(response);
    } catch (error) {
      print(".........>$error");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
