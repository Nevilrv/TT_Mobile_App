import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/all_categories_response_model.dart';

class AllCategoriesRepo extends ApiService {
  Future<dynamic> allCategoriesRepo() async {
    print('url video ==== ${ApiRoutes.getCategories}');

    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: ApiRoutes.getCategories);

    CategoriesResponseModel allCategoriesResponseModel =
        CategoriesResponseModel.fromJson(response);
    return allCategoriesResponseModel;
  }
}
