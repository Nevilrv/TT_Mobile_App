import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/habit_tracker_model/habit_model.dart';

class HabitRepo extends ApiRoutes {
  Future<dynamic> habitRepo({String? userId}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: habitTrackerUrl + userId!);

    HabitResponseModel habitResponseModel =
        HabitResponseModel.fromJson(response);
    return habitResponseModel;
  }
}
