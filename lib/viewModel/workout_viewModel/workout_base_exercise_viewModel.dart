import 'package:get/get.dart';

class WorkoutBaseExerciseViewModel extends GetxController {
  List exerciseId = ['3', '5', '7', '2', '27', '15', '10', '17', '20'];
  int exeIdCounter = 0;

  getExeId({int? counter}) {
    if (counter! < exerciseId.length) {
      exeIdCounter++;
    }
    update();
  }

  getBackId({int? counter}) {
    if (counter! > 0) {
      exeIdCounter--;
    }
    update();
  }
}
