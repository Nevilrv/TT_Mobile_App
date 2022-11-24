import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/goal_res_model.dart';

import '../repo/goal_repo.dart';

class GoalViewModel extends GetxController {
  bool isLoading = false;
  setLoading(value) {
    isLoading = value;
    update();
  }

  List selectedGoalList = [];

  selectedGoals({String? goals}) {
    if (selectedGoalList.contains(goals)) {
      selectedGoalList.remove(goals);
    } else {
      selectedGoalList.add(goals);
    }
    update();
  }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;

  Future<void> goals() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      GoalsResModel response = await GoalRepo().goalRepo();
      _apiResponse = ApiResponse.complete(response);
    } catch (error) {
      print(".........>$error");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
