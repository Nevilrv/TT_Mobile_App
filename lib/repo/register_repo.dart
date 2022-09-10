import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/register_response_model.dart';

class RegisterRepo extends ApiRoutes {
  Future<dynamic> registerRepo(Map<String, dynamic> body) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: registerUrl, body: body);

    RegisterResponseModel registerResponseModel =
        RegisterResponseModel.fromJson(response);
    return registerResponseModel;
  }
}
