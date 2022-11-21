import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/forum_response_model/get_category_tag_response_model.dart';

class GetCategoryTagRepo extends ApiRoutes {
  Future<dynamic> getCategoryTagRepo({String? categoryId}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: getCategoryTags + categoryId!);

    print('getCategoryTagResponseModel ----------- $response');

    GetCategoryTagResponseModel getCategoryTagResponseModel =
        GetCategoryTagResponseModel.fromJson(response);
    return getCategoryTagResponseModel;
  }
}
