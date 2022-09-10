import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/user_detail_response_model.dart';
import 'package:tcm/repo/user_detail_repo.dart';

class UserDetailViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get apiResponse => _apiResponse;
  late UserdetailResponseModel response;
  Future<void> userDetailViewModel({String? id}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');

    try {
      print('trsp==UserdetailResponseModel=>');
      response = await UserDetailRepo().userDetailRepo(id: id);
      print('trsp==UserdetailResponseModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print(".........   $e");
    }
    update();
  }
}
