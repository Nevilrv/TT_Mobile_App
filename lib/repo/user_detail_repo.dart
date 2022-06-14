import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/user_detail_response_model.dart';

class UserDetailRepo extends ApiRoutes {
  Future<dynamic> userDetailRepo({String? id}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: userDetailUrl + id!);

    UserdetailResponseModel userdetailResponseModel =
        UserdetailResponseModel.fromJson(response);
    return userdetailResponseModel;
  }
}
