import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SuperSetSecondScreen extends StatefulWidget {
  const SuperSetSecondScreen({Key? key}) : super(key: key);

  @override
  State<SuperSetSecondScreen> createState() => _SuperSetSecondScreenState();
}

class _SuperSetSecondScreenState extends State<SuperSetSecondScreen> {
  List<String> exeName = ["Dead Lift", "Pull-ups", "Bicep Curls"];
  int counter = 0;

  bool watchVideo = false;
  var a;
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youTubePlayerController;

  ChewieController? _chewieController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorUtils.kTint,
            )),
        backgroundColor: ColorUtils.kBlack,
        title: Text('Superset', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Get.offAll(HomeScreen());
              },
              child: Text(
                'Quit',
                style: FontTextStyle.kTine16W400Roboto,
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          width: Get.width,
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Get.height * .027),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Superset',
                    style: FontTextStyle.kWhite24BoldRoboto
                        .copyWith(fontSize: Get.height * .03),
                  ),
                  SizedBox(height: Get.height * .015),
                  Text('3 rounds', style: FontTextStyle.kLightGray18W300Roboto),
                  SizedBox(height: Get.height * .008),
                  Text('30 secs rest between rounds',
                      style: FontTextStyle.kLightGray18W300Roboto),
                ],
              ),
            ),
            Container(
              height: Get.height * .055,
              width: Get.width * .33,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: ColorUtilsGradient.kGrayGradient,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Round', style: FontTextStyle.kWhite18BoldRoboto),
                  SizedBox(width: Get.width * .02),
                  CircleAvatar(
                      radius: Get.height * .019,
                      backgroundColor: ColorUtils.kTint,
                      child: Text(
                        '1',
                        style: FontTextStyle.kBlack20BoldRoboto,
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * .03,
                  left: Get.height * .04,
                  right: Get.height * .04),
              child: SizedBox(
                width: Get.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: exeName.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !watchVideo
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      watchVideo = true;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text('${exeName[index]}',
                                          style: FontTextStyle
                                              .kWhite24BoldRoboto
                                              .copyWith(
                                            fontSize: Get.height * .026,
                                          )),
                                      SizedBox(width: Get.width * .03),
                                      Container(
                                        height: Get.height * .04,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ColorUtils.kBlack,
                                            border: Border.all(
                                                color: ColorUtils.kTint,
                                                width: 2)),
                                        child: Icon(Icons.play_arrow_outlined,
                                            size: Get.height * .03,
                                            color: ColorUtils.kTint),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(),
                          watchVideo
                              ? AnimatedContainer(
                                  height: Get.height / 3.5,
                                  width: Get.width,
                                  duration: Duration(seconds: 2),
                                  child: 'string'.contains('www.youtube.com')
                                      ? Center(
                                          child: _youTubePlayerController ==
                                                  null
                                              ? CircularProgressIndicator(
                                                  color: ColorUtils.kTint)
                                              : YoutubePlayer(
                                                  controller:
                                                      _youTubePlayerController!,
                                                  showVideoProgressIndicator:
                                                      true,
                                                  bufferIndicator:
                                                      CircularProgressIndicator(
                                                          color:
                                                              ColorUtils.kTint),
                                                  controlsTimeOut:
                                                      Duration(hours: 2),
                                                  aspectRatio: 16 / 9,
                                                  progressColors:
                                                      ProgressBarColors(
                                                          handleColor: ColorUtils
                                                              .kRed,
                                                          playedColor: ColorUtils
                                                              .kRed,
                                                          backgroundColor:
                                                              ColorUtils.kGray,
                                                          bufferedColor:
                                                              ColorUtils
                                                                  .kLightGray),
                                                ),
                                        )
                                      : Center(
                                          child: _chewieController != null &&
                                                  _chewieController!
                                                      .videoPlayerController
                                                      .value
                                                      .isInitialized
                                              ? Chewie(
                                                  controller:
                                                      _chewieController!,
                                                )
                                              : a == null
                                                  ? noDataLottie()
                                                  : Image.network(
                                                      "$a",
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return noDataLottie();
                                                      },
                                                    )),
                                )
                              : SizedBox(),
                          SizedBox(height: Get.height * .005),
                          Text(
                            '10 reps',
                            style: FontTextStyle.kLightGray18W300Roboto,
                          ),
                          SizedBox(height: Get.height * .0075),
                          CounterCard(counter: counter),
                          Divider(
                              height: Get.height * .06,
                              color: ColorUtils.kLightGray)
                        ],
                      );
                    }),
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    top: Get.height * .01,
                    bottom: Get.height * .04,
                    left: Get.height * .04,
                    right: Get.height * .04),
                alignment: Alignment.center,
                width: Get.width,
                height: Get.height * .055,
                decoration: BoxDecoration(
                    color: ColorUtils.kSaperatedGray,
                    borderRadius: BorderRadius.circular(6)),
                child: Text(
                  '30 second rest',
                  style: FontTextStyle.kWhite17W400Roboto,
                )),
            Padding(
                padding: EdgeInsets.only(
                    left: Get.height * .03,
                    right: Get.height * .03,
                    bottom: Get.height * .05),
                child: commonNavigationButton(name: "Next Round", onTap: () {}))
          ]),
        ),
      ),
    );
  }
}

class CounterCard extends StatefulWidget {
  int counter;

  CounterCard({Key? key, required this.counter}) : super(key: key);

  @override
  State<CounterCard> createState() => _CounterCardState();
}

class _CounterCardState extends State<CounterCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: Get.height * .1,
            width: Get.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: ColorUtilsGradient.kGrayGradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(6)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if (widget.counter > 0) widget.counter--;
                  });
                  print('minus ${widget.counter}');
                },
                child: CircleAvatar(
                  radius: Get.height * .03,
                  backgroundColor: ColorUtils.kTint,
                  child: Icon(Icons.remove, color: ColorUtils.kBlack),
                ),
              ),
              SizedBox(width: Get.width * .08),
              RichText(
                  text: TextSpan(
                      text: '${widget.counter} ',
                      style: widget.counter == 0
                          ? FontTextStyle.kWhite24BoldRoboto
                              .copyWith(color: ColorUtils.kGray)
                          : FontTextStyle.kWhite24BoldRoboto,
                      children: [
                    TextSpan(
                        text: 'reps', style: FontTextStyle.kWhite17W400Roboto)
                  ])),
              SizedBox(width: Get.width * .08),
              InkWell(
                onTap: () {
                  setState(() {
                    widget.counter++;
                  });
                  print('plus ${widget.counter}');
                },
                child: CircleAvatar(
                  radius: Get.height * .03,
                  backgroundColor: ColorUtils.kTint,
                  child: Icon(Icons.add, color: ColorUtils.kBlack),
                ),
              ),
              VerticalDivider(
                width: Get.width * .08,
                thickness: 1.25,
                color: ColorUtils.kBlack,
                indent: Get.height * .015,
                endIndent: Get.height * .015,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: TextField(
                          style: widget.counter == 0
                              ? FontTextStyle.kWhite24BoldRoboto
                                  .copyWith(color: ColorUtils.kGray)
                              : FontTextStyle.kWhite24BoldRoboto,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          cursorColor: ColorUtils.kTint,
                          decoration: InputDecoration(
                              hintText: '0',
                              counterText: '',
                              semanticCounterText: '',
                              hintStyle: FontTextStyle.kWhite24BoldRoboto
                                  .copyWith(color: ColorUtils.kGray),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                        ),
                      ),
                      Text('lbs', style: FontTextStyle.kWhite17W400Roboto),
                    ],
                  ),
                  SizedBox(),
                ],
              ),
            ]),
          ),
          Container(
            alignment: Alignment.center,
            height: Get.height * .027,
            width: Get.height * .09,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: ColorUtilsGradient.kOrangeGradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6))),
            child: Text('RIR 0-1',
                style: FontTextStyle.kWhite12BoldRoboto
                    .copyWith(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
