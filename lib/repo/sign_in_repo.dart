import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/sign_in_response_model.dart';

class SignInRepo extends ApiRoutes {
  Future<dynamic> signInRepo(Map<String, dynamic> body) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: signInUrl, body: body);

    SignInResponseModel signInResponseModel =
        SignInResponseModel.fromJson(response);
    return signInResponseModel;
  }
}
