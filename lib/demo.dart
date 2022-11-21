import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'custom_packages/vimeo_video_player/vimeo_video_player.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height / 2.75,
        width: Get.width,
        child: Center(
          child: VimeoVideoPlayer(
            url: 'https://vimeo.com/70591644',
            deviceOrientation: DeviceOrientation.portraitUp,
            systemUiOverlay: const [
              SystemUiOverlay.top,
              SystemUiOverlay.bottom,
            ],
          ),
        ),
      ),
    );
  }
}
