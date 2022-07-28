import 'package:get/get.dart';

class WorkoutBaseExerciseViewModel extends GetxController {
  List exerciseId = ['5', '7', '27', '15'];
  int exeIdCounter = 0;

  getExeId({int? counter}) {
    if (counter! <= exerciseId.length) {
      exeIdCounter++;
    }
  }
}
