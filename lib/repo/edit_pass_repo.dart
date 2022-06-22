import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/edit_pass_response_model.dart';

class EditPassRepo extends ApiRoutes {
  Future<dynamic> editPassRepo(Map<String, dynamic> body) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: editPassUrl, body: body);

    EditPassResponseModel editPassResponseModel =
        EditPassResponseModel.fromJson(response);
    return editPassResponseModel;
  }
}
