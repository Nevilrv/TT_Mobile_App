import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/forum_response_model/get_category_tag_response_model.dart';
import 'package:tcm/repo/forum_repo/get_category_tag_repo.dart';

class GetCategoryTagViewModel extends GetxController {
  List allTagTitle = [];
  List valueFinal = [];
  void setValueFinal(var value) {
    valueFinal = value;
    update();
  }

  String _selectTagId = '';

  String get selectTagId => _selectTagId;

  void setSelectTagId(String value) {
    _selectTagId = value;
    update();
  }

  String _selectedTagTitle = '';

  String get selectedTagTitle => _selectedTagTitle;

  void setSelectedTagTitle(String value) {
    _selectedTagTitle = value;
    update();
  }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;

  Future<void> getCategoryTagViewModel({String? categoryId}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      GetCategoryTagResponseModel response =
          await GetCategoryTagRepo().getCategoryTagRepo(categoryId: categoryId);
      _apiResponse = ApiResponse.complete(response);
      print("getCategoryTagResponseModel$response");
    } catch (error) {
      print(".........>$error");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
