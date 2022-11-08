import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/subscription_res_model.dart';
import 'package:tcm/model/response_model/user_detail_response_model.dart';

class SubscriptionRepo extends ApiRoutes {
  Future<dynamic> subscriptionRepo({String? id}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: subscriptionUrl + id!);

    SubscriptionResponseModel subscriptionResponseModel =
        SubscriptionResponseModel.fromJson(response);
    return subscriptionResponseModel;
  }
}
