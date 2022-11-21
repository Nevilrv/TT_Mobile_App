import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/create_subscription_res_model.dart';

class CreateSubscriptionRepo extends ApiRoutes {
  Future<dynamic> createSubscriptionRepo(
      Map<String, dynamic> body, String url) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: url, body: body);

    CreateSubscriptionResponseModel createSubscriptionResponseModel =
        CreateSubscriptionResponseModel.fromJson(response);
    return createSubscriptionResponseModel;
  }
}
