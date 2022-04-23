import 'package:auto_size_text/auto_size_text.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/all_workout_res_model.dart';
import 'package:tcm/screen/training_plan_screens/workout_overview_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/all_workout_viewModel.dart';
import 'package:video_player/video_player.dart';

class ChestAndBackBlastScreen extends StatefulWidget {
  const ChestAndBackBlastScreen({Key? key}) : super(key: key);

  @override
  _ChestAndBackBlastScreenState createState() =>
      _ChestAndBackBlastScreenState();
}

class _ChestAndBackBlastScreenState extends State<ChestAndBackBlastScreen> {
  AllWorkoutViewModel _allWorkoutViewModel = Get.put(AllWorkoutViewModel());
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _allWorkoutViewModel.getPackageDetails();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  List<String> srcs = [
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  Future<void> initializePlayer() async {
    _videoPlayerController1 =
        VideoPlayerController.network(srcs[currPlayIndex]);
    _videoPlayerController2 =
        VideoPlayerController.network(srcs[currPlayIndex]);
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    final subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text: const TextSpan(
          children: [],
        ),
      ),
      Subtitle(
        index: 0,
        start: const Duration(seconds: 10),
        end: const Duration(seconds: 20),
        text: 'Whats up? :)',
        // text: const TextSpan(
        //   text: 'Whats up? :)',
        //   style: TextStyle(color: Colors.amber, fontSize: 22, fontStyle: FontStyle.italic),
        // ),
      ),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
          ),
        ];
      },
      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),
      hideControlsTimer: const Duration(seconds: 1),
    );
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex = currPlayIndex == 0 ? 1 : 0;
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllWorkoutViewModel>(
      builder: (controller) {
        if (controller.apiResponse.status == Status.COMPLETE) {
          AllWorkOutResponseModel response = controller.apiResponse.data;
          return Scaffold(
            backgroundColor: ColorUtils.kBlack,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: ColorUtils.kTint,
                  )),
              backgroundColor: ColorUtils.kBlack,
              title: Text('${response.data![0].workoutTitle}',
                  style: FontTextStyle.kWhite16BoldRoboto),
              centerTitle: true,
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: InkWell(
                      onTap: () {},
                      child:
                          Text('Start', style: FontTextStyle.kTine16W400Roboto),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  height: Get.height / 2.75,
                  width: Get.width,
                  child: Center(
                    child: _chewieController != null &&
                            _chewieController!
                                .videoPlayerController.value.isInitialized
                        ? Chewie(
                            controller: _chewieController!,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              CircularProgressIndicator(),
                              SizedBox(height: 20),
                              Text('Loading'),
                            ],
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 15),
                        width: Get.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Image.asset(AppIcons.calender,
                                    height: 15, width: 15),
                                SizedBox(width: 5),
                                Text('${response.data![0].workoutGoal} WEEKS',
                                    style: FontTextStyle.kWhite16BoldRoboto),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(AppIcons.clock,
                                    height: 15, width: 15),
                                SizedBox(width: 5),
                                Text(
                                    '${response.data![0].workoutDuration}x PER WEEK',
                                    style: FontTextStyle.kWhite16BoldRoboto),
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(AppIcons.medal,
                                    height: 15, width: 15),
                                SizedBox(width: 5),
                                Text("${response.data![0].levelTitle}",
                                    style: FontTextStyle.kWhite16BoldRoboto),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text("${response.data![0].workoutDescription}",
                          maxLines: 5, style: FontTextStyle.kWhite16W300Roboto),
                      Container(
                        padding: EdgeInsets.only(top: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'VIEW WORKOUTS',
                          style: FontTextStyle.kWhite16BoldRoboto,
                        ),
                      ),
                      Divider(
                        color: ColorUtils.kTint,
                        thickness: 1,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * .012),
                        child: Container(
                          height: Get.height * 0.15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print('Button pressed');
                                  Get.to(WorkoutOverviewPage());
                                },
                                child: exerciseDayButton(
                                  day: 'Day 1',
                                  exercise: 'Chest',
                                ),
                              ),
                              GestureDetector(
                                child: exerciseDayButton(
                                  day: 'Day 2',
                                  exercise: 'Back',
                                ),
                              ),
                              GestureDetector(
                                child: exerciseDayButton(
                                  day: 'Day 3',
                                  exercise: 'Chest/Back Iso Work',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            bottom: 15, top: 5, right: 12, left: 12),
                        alignment: Alignment.center,
                        height: Get.height * 0.06,
                        width: Get.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: ColorUtilsGradient.kTintGradient,
                                begin: Alignment.topCenter,
                                end: Alignment.topCenter),
                            borderRadius:
                                BorderRadius.circular(Get.height * 0.1)),
                        child: Text('Start Program',
                            style: FontTextStyle.kBlack20BoldRoboto),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Row exerciseDayButton({String? day, String? exercise}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(
                text: '${day} - ',
                style: FontTextStyle.kWhite16BoldRoboto,
                children: [
              TextSpan(text: exercise, style: FontTextStyle.kWhite16W300Roboto)
            ])),
        Icon(
          Icons.arrow_forward_ios_sharp,
          color: ColorUtils.kTint,
          size: Get.height * 0.026,
        )
      ],
    );
  }
}
