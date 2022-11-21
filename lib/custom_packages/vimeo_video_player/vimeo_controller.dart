import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:video_player/video_player.dart';

class VimeoController extends GetxController {
  late VideoPlayerController videoPlayerController;

  videoUrl({String? url}) {
    videoPlayerController = VideoPlayerController.network(url!);
    update();
  }

  videoDispose() {
    videoPlayerController.dispose();
    update();
  }

  videoPause() {
    videoPlayerController.pause();
    update();
  }

  var _res;

  get res => _res;

  set res(value) {
    _res = value;
  }

  int get index => _index;

  set index(int value) {
    _index = value;
  }

  int _index = 0;
}
