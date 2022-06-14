import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/edit_profile_response_model.dart';

class EditProfileRepo extends ApiRoutes {
  Future<dynamic> editProfileRepo(Map<String, dynamic> body) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: editProfileUrl, body: body);

    EditProfileResponseModel editProfileResponseModel =
        EditProfileResponseModel.fromJson(response);
    return editProfileResponseModel;
  }
}
