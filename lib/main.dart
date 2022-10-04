import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:tcm/screen/splash_screen.dart';

import 'screen/workout_screen/amrap_screen.dart';

void main() async {
  ///ne
  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(MyApp()));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

      // home: YoutubePlayerDemoApp(),
    );
  }
}
