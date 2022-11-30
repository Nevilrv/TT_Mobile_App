import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/check_email_exists_response_model.dart';

class CheckEmailExistsRepo extends ApiRoutes {
  Future<dynamic> checkEmailExistsRepo(Map<String, dynamic> body) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: checkEmailExists, body: body);

    CheckEmailExistsResponseModel checkEmailExistsResponseModel =
        CheckEmailExistsResponseModel.fromJson(response);
    return checkEmailExistsResponseModel;
  }
}
