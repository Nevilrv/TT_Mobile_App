import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/all_bodyparts_response_model.dart';

class AllBodyPartsRepo extends ApiService {
  Future<dynamic> allBodyPartsRepo() async {
    print('url video ==== ${ApiRoutes.getBodyParts}');

    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: ApiRoutes.getBodyParts);

    BodyPartsResponseModel allBodyPartsResponseModel =
        BodyPartsResponseModel.fromJson(response);
    return allBodyPartsResponseModel;
  }
}
