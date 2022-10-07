import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:http/http.dart' as http;
import 'package:tcm/utils/ColorUtils.dart';

class DeleteFile extends StatefulWidget {
  const DeleteFile({Key? key}) : super(key: key);

  @override
  State<DeleteFile> createState() => _DeleteFileState();
}

class _DeleteFileState extends State<DeleteFile> {
  Timer? resTimer;
  int? showTimer;

  int currentValue = 0;
  void startRestTimer() {
    resTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (currentValue >= 0 && currentValue < 15) {
          setState(() {
            currentValue++;
            print('count>>>>>$currentValue');
          });
        } else {
          print('Timer Cancel');
          setState(() {
            currentValue = 0;
            showTimer = null;
            resTimer!.cancel();
          });
        }
      },
    );
  }

  editPassRepo({required String passId}) async {
    http.Response MILAN = await http.get(Uri.parse(
        'https://tcm.sataware.dev/json/data_exercises.php?exercise=$passId'));

    if (MILAN.statusCode == 200) {
      var m = jsonDecode(MILAN.body);
      listOfWidget
          .add(widgetOf(textOf: passId, data: m['data'][0]['exercise_title']));
      setState(() {});

      return true;
    } else {
      setState(() {});

      return false;
    }
  }

  List listOfWidget = [];
  int index = 0;
  List fetchId = ['4', '6', '9'];
  List intCount = [0, 0, 0];
  int count = 0;
  widgetOf({
    required String textOf,
    required String data,
  }) {
    return Container(
      color: Colors.red.shade50,
      height: 400,
      width: 400,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(textOf, style: TextStyle(color: Colors.black, fontSize: 35)),
            Text(data, style: TextStyle(color: Colors.black, fontSize: 35)),
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    editPassRepo(passId: fetchId[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          listOfWidget.length == 0
              ? Container(
                  height: 400,
                  width: 400,
                  child: Center(child: CircularProgressIndicator()))
              : Column(children: [
                  listOfWidget[index],
                  ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (showTimer == null) {
                            } else {
                              resTimer!.cancel();
                            }
                            showTimer = index;
                            currentValue = 0;
                            startRestTimer();
                          },
                          child: showTimer == index
                              ? Container(
                                  width: 400,
                                  height: 35,
                                  // color: Colors.grey.shade50,
                                  child: FAProgressBar(
                                    animatedDuration: Duration(seconds: 1),
                                    currentValue: currentValue.toDouble(),
                                    backgroundColor: ColorUtils.kLightGray,
                                    progressColor: ColorUtils.kGreen,
                                    maxValue: 15,
                                  ),
                                )
                              : Container(
                                  width: 400,
                                  height: 35,
                                  color: Colors.grey,
                                ),
                        ),
                      );
                    },
                  )
                ]),
          TextButton(
              onPressed: () {
                if (index == 0) {
                  editPassRepo(passId: '2');
                  index = 1;
                } else if (index == 1) {
                  editPassRepo(passId: '3');

                  index = 2;
                } else {
                  index = 0;
                }
                setState(() {});
              },
              child: Text(
                'press',
                style: TextStyle(color: Colors.red, fontSize: 20),
              )),
          TextButton(
              onPressed: () {
                if (index == 0) {
                  print('back print');
                } else if (index == 1) {
                  index = index - 1;
                } else {
                  index = index - 1;
                }
                setState(() {});
              },
              child: Text(
                'back',
                style: TextStyle(color: Colors.red, fontSize: 20),
              )),
          TextButton(
              onPressed: () {
                // startRestTimer();

                setState(() {});
              },
              child: Text(
                'back',
                style: TextStyle(color: Colors.red, fontSize: 20),
              )),
        ]),
      ),
    );
  }
}
