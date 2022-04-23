import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';

import '../model/response_model/all_workout_res_model.dart';

class AllWorkoutRepo extends ApiService {
  Future<dynamic> allWorkoutRepo() async {
    print('url ==== ${ApiRoutes.getAllWorkout}');
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: ApiRoutes.getAllWorkout);
    AllWorkOutResponseModel allWorkOutResponseModel =
        AllWorkOutResponseModel.fromJson(response);
    return allWorkOutResponseModel;
  }
}
