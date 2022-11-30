import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/check_email_exists_response_model.dart';
import 'package:tcm/repo/check_email_exists_repo.dart';

class CheckEmailExistsViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late CheckEmailExistsResponseModel response;
  Future<void> checkEmailExistsViewModel(body) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      print('trsp==CheckEmailExistsResponseModel=>');
      response = await CheckEmailExistsRepo().checkEmailExistsRepo(body);
      print('trsp==CheckEmailExistsResponseModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print(".........   $e");
    }
    update();
  }
}
