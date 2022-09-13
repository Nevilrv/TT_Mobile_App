import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/update_status_user_program_response_model.dart';

class UpdateStatusUserProgramRepo extends ApiRoutes {
  Future<dynamic> updateStatusUserProgramRepo(Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: updateStatusOfUserProgram, body: body);

    UpdateStatusUserProgramResponseModel updateStatusUserProgramResponseModel =
        UpdateStatusUserProgramResponseModel.fromJson(response);
    return updateStatusUserProgramResponseModel;
  }
}
