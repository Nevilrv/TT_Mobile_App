import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/forum_response_model/get_tags_response_model.dart';
import 'package:tcm/repo/forum_repo/get_tags_response_model.dart';

class GetTagsViewModel extends GetxController {
  List allTagTitle = [];
  ApiResponse _getTagsApiResponse =
      ApiResponse.initial(message: 'Initialization');

  ApiResponse get getTagsApiResponse => _getTagsApiResponse;

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

  List valueFinal = [];
  void setValueFinal(var value) {
    valueFinal = value;
    update();
  }

  late GetTagsResponseModel response;
  Future<void> getTagsViewModel(
      {String? title, required String? categoryId}) async {
    if (_getTagsApiResponse.status == Status.INITIAL) {
      _getTagsApiResponse = ApiResponse.loading(message: 'Loading');
      update();
    }

    try {
      print('==_getTagsApiResponse=>');
      response =
          await GetTagsRepo().getTagsRepo(title: title, categoryId: categoryId);
      print('==_getTagsApiResponse=>$response');

      _getTagsApiResponse = ApiResponse.complete(response);
    } catch (e) {
      _getTagsApiResponse = ApiResponse.error(message: e.toString());
      print("......... _getTagsApiResponse ===== $e");
    }
    update();
  }
}
