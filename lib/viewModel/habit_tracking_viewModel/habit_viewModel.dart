import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/habit_tracker_model/habit_model.dart';
import 'package:tcm/repo/habit_tracker_repo/habits_repo.dart';
import 'package:tcm/utils/images.dart';

class HabitViewModel extends GetxController {
  var isAlertOpen = false;
  int? selectedIndex = 0;
  List selectedHabitList = [];

  List habitUpdatesList = [];
  double? percent = 0;

  String selectedBodyIllu = AppImages.body_illustration[0];

  frequencySelect({int? value}) {
    selectedIndex = value;
    update();
  }

  // showProgressImage() {
  //   update();
  // }

  progressCounter({int? selectedHabitListLength, int? totalListLength}) {
    percent = 100 * selectedHabitListLength! / totalListLength!;
    if (percent == 0) {
      print('percent ======= $percent');
      return selectedBodyIllu = AppImages.body_illustration[0];
    } else if (percent! <= 12.5) {
      print('percent ======= $percent');
      selectedBodyIllu = AppImages.body_illustration[1];
      update();
    } else if (percent! <= 25) {
      print('percent ======= $percent');
      selectedBodyIllu = AppImages.body_illustration[2];
      update();
    } else if (percent! <= 37.5) {
      print('percent ======= $percent');
      selectedBodyIllu = AppImages.body_illustration[3];
      update();
    } else if (percent! <= 50) {
      print('percent ======= $percent');
      selectedBodyIllu = AppImages.body_illustration[4];
      update();
    } else if (percent! <= 62.5) {
      print('percent ======= $percent');
      selectedBodyIllu = AppImages.body_illustration[5];
      update();
    } else if (percent! <= 75) {
      print('percent ======= $percent');
      selectedBodyIllu = AppImages.body_illustration[6];
      update();
    } else if (percent! <= 87.5) {
      print('percent ======= $percent');
      selectedBodyIllu = AppImages.body_illustration[7];
      update();
    } else if (percent! <= 100) {
      print('percent ======= $percent');
      selectedBodyIllu = AppImages.body_illustration[8];
      update();
    }
    print('percent ---- ${percent}');
    print('totalListLength ---- ${totalListLength}');
    update();
  }

  selectedHabits({String? habits}) {
    if (selectedHabitList.contains(habits)) {
      selectedHabitList.remove(habits);
    } else {
      selectedHabitList.add(habits);
    }
    update();
  }

  updateSelectedHabits({String? habits}) {
    if (habitUpdatesList.contains(habits)) {
      habitUpdatesList.remove(habits);
    } else {
      habitUpdatesList.add(habits);
    }
    update();
  }

  habitUpdates({String? habits}) {
    if (habitUpdatesList.contains(habits)) {
      habitUpdatesList.remove(habits);
    } else {
      habitUpdatesList.add(habits);
    }
    update();
  }

  changeStatus() {
    if (isAlertOpen) {
      isAlertOpen = false;
    } else {
      isAlertOpen = true;
    }
    update();
  }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;

  Future<void> getHabitDetail() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      HabitResponseModel response = await HabitRepo().habitRepo();
      _apiResponse = ApiResponse.complete(response);
    } catch (error) {
      print(".........>$error");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
