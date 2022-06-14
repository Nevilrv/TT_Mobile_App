import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/exp_res_model.dart';
import 'package:tcm/model/response_model/goal_res_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/habit_model.dart';

class GoalRepo extends ApiRoutes {
  Future<dynamic> goalRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: goalUrl);

    GoalsResModel goalsResModel = GoalsResModel.fromJson(response);
    return goalsResModel;
  }
}
