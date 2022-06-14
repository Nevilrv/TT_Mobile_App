import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/days_model/days_model.dart';
import 'package:tcm/repo/days_repo/days_repo.dart';

class DayViewModel extends GetxController {
  dayRepoSelector(int indexSet) {
    if (indexSet == 0) {
      print("_index_index_index $indexSet");
      return DayOneRepo().dayOneRepo();
    } else if (indexSet == 1) {
      print("_index_index_index $indexSet");
      return DayTwoRepo().dayTwoRepo();
    } else if (indexSet == 2) {
      print("_index_index_index $indexSet");
      return DayThreeRepo().dayThreeRepo();
    } else if (indexSet == 3) {
      print("_index_index_index $indexSet");
      return DayFourRepo().dayFourRepo();
    } else if (indexSet == 4) {
      print("_index_index_index $indexSet");
      return DayFiveRepo().dayFiveRepo();
    } else if (indexSet == 5) {
      print("_index_index_index $indexSet");
      return DaySixRepo().daySixRepo();
    } else if (indexSet == 6) {
      print("_index_index_index $indexSet");
      return DaySevenRepo().daySevenRepo();
    }
  }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;

  Future<void> getWorkoutByDayDetail(int index) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      print('DaysResponseModelindex ===== $index');
      DaysResponseModel response = await dayRepoSelector(index);
      _apiResponse = ApiResponse.complete(response);
    } catch (error) {
      print(".........>$error");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
