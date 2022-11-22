import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forum_category_response_model.dart';
import 'package:tcm/repo/forum_repo/get_all_forum_category_repo.dart';

class GetAllForumCategoryViewModel extends GetxController {
  List allCategory = [];
  List allCategoryId = [];
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;

  Future<void> getAllForumCategoryViewModel() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      GetAllForumCategoryResponseModel response =
          await GetAllForumCategoryRepo().getAllForumCategoryRepo();
      _apiResponse = ApiResponse.complete(response);
      print("getAllForumCategoryViewModel$response");
    } catch (error) {
      print(".........>$error");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
