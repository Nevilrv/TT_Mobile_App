import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/forum_viewModel/all_comment_viewmodel.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../viewModel/forum_viewModel/add_forum_viewmodel.dart';

class TrimmerView extends StatefulWidget {
  final File file;
  final bool commentScreen;
  final String postId;

  TrimmerView(this.file, this.commentScreen, this.postId);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();
  AddForumViewModel addForumViewModel = Get.put(AddForumViewModel());

  double _startValue = 0.0;
  double _endValue = 0.0;
  bool _isPlaying = false;
  bool _progressVisibility = false;
  TextEditingController captionController = TextEditingController();
  ScrollController? scrollcontroller = ScrollController();

  AllCommentViewModel allCommentViewModel = Get.put(AllCommentViewModel());
  String? value;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    await _trimmer.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        onSave: (String? outputPath) {
          print('outpath **** ${outputPath}');
          if (outputPath!.isNotEmpty && outputPath != "") {
            setState(() {
              _progressVisibility = false;
              value = outputPath;
              print('fghjkl >>> $value');
            });
          } else {
            print('not at all');
          }
        });

    return value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    print('comment screen >>> ${widget.commentScreen}');
    print('Width??? ${Get.width}');
    return widget.commentScreen == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  icon: Icon(Icons.close, color: ColorUtils.kTint),
                  onPressed: () {
                    Get.back();
                  }),
              actions: [
                GetBuilder<AddForumViewModel>(
                  builder: (controller) {
                    return _progressVisibility
                        ? SizedBox()
                        : GetBuilder<AddForumViewModel>(
                            builder: (controller) {
                              return TextButton(
                                onPressed: () async {
                                  setState(() {
                                    _progressVisibility = true;
                                  });
                                  await _trimmer.saveTrimmedVideo(
                                      startValue: _startValue,
                                      endValue: _endValue,
                                      onSave: (String? outputPath) async {
                                        // setState(() {
                                        _progressVisibility = false;
                                        value = outputPath!;
                                        // });
                                        print('fghjkl >>> $value');
                                        print('outpath **** ${outputPath}');
                                        final uint8list =
                                            await VideoThumbnail.thumbnailData(
                                          video: widget.file.path,
                                          imageFormat: ImageFormat.JPEG,
                                          maxHeight: 250,
                                          maxWidth: 250,
                                          quality: 50,
                                        );
                                        Uint8List imageInUnit8List =
                                            uint8list!; // store unit8List image here ;
                                        final tempDir =
                                            await getTemporaryDirectory();
                                        File file = await File(
                                                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png')
                                            .create();
                                        file.writeAsBytesSync(imageInUnit8List);
                                        var a = await controller.videoInfo
                                            .getVideoInfo(widget.file.path);
                                        print('value ???? $value');
                                        controller.dataAddInFileAll(
                                            File(outputPath),
                                            file,
                                            a!.filesize,
                                            a.duration);
                                        print(
                                            '12122 ==== >>>> ${controller.filesAll}');
                                        Get.back();
                                      });
                                },
                                child: Text("Add",
                                    style: TextStyle(
                                        color: ColorUtils.kTint, fontSize: 18)),
                              );
                            },
                          );
                  },
                )
              ],
            ),
            body: Builder(
              builder: (context) => Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Visibility(
                        visible: _progressVisibility,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      ),
                      Expanded(
                        child: VideoViewer(trimmer: _trimmer),
                      ),
                      Center(
                        child: TrimEditor(
                          trimmer: _trimmer,
                          viewerHeight: 50.0,
                          viewerWidth: MediaQuery.of(context).size.width,
                          maxVideoLength: Duration(seconds: 59),
                          onChangeStart: (value) {
                            _startValue = value;
                          },
                          onChangeEnd: (value) {
                            _endValue = value;
                          },
                          onChangePlaybackState: (value) {
                            setState(() {
                              _isPlaying = value;
                            });
                          },
                        ),
                      ),
                      TextButton(
                        child: _isPlaying
                            ? Icon(
                                Icons.pause,
                                size: 80.0,
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 80.0,
                                color: Colors.white,
                              ),
                        onPressed: () async {
                          bool playbackState =
                              await _trimmer.videPlaybackControl(
                            startValue: _startValue,
                            endValue: _endValue,
                          );
                          setState(() {
                            _isPlaying = playbackState;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  icon: Icon(Icons.close, color: ColorUtils.kTint),
                  onPressed: () {
                    Get.back();
                  }),
              actions: [
                GetBuilder<AddForumViewModel>(
                  builder: (controller) {
                    return _progressVisibility
                        ? SizedBox()
                        : GetBuilder<AllCommentViewModel>(
                            builder: (controller) {
                              return TextButton(
                                onPressed: () async {
                                  print('Enter in comment post video **** ');
                                  setState(() {
                                    _progressVisibility = true;
                                  });
                                  await _trimmer.saveTrimmedVideo(
                                      startValue: _startValue,
                                      endValue: _endValue,
                                      onSave: (String? outputPath) async {
                                        _progressVisibility = false;
                                        value = outputPath!;
                                        print('value of video >>> $value');
                                        print(
                                            'Output path of video trimmer **** ${outputPath}');

                                        print(
                                            'Post added >>>> ${widget.postId}');
                                        var request = http.MultipartRequest(
                                            'POST',
                                            Uri.parse(
                                                'https://tcm.sataware.dev/json/data_forum_comments.php'));
                                        request.fields.addAll({
                                          'post_id': widget.postId.toString(),
                                          'user_id': PreferenceManager.getUId(),
                                          'comment': '',
                                          'type': 'video',
                                          'caption': captionController.text
                                        });
                                        request.files.add(
                                            await http.MultipartFile.fromPath(
                                                'image[]', outputPath));

                                        http.StreamedResponse response =
                                            await request.send();

                                        if (response.statusCode == 200) {
                                          print(await response.stream
                                              .bytesToString());

                                          captionController.clear();
                                          await controller
                                              .getAllCommentsViewModel(
                                            postId: widget.postId,
                                          )
                                              .then((value) {
                                            Future.delayed(Duration(seconds: 2),
                                                () {
                                              scrollcontroller!.animateTo(
                                                scrollcontroller!
                                                    .position.maxScrollExtent,
                                                duration: Duration(seconds: 1),
                                                curve: Curves.fastOutSlowIn,
                                              );
                                            });
                                            Get.back();
                                            Get.showSnackbar(GetSnackBar(
                                              duration: Duration(seconds: 2),
                                              messageText: Text(
                                                'Comment video added....',
                                                style: FontTextStyle
                                                    .kTine17BoldRoboto,
                                              ),
                                            ));
                                          });
                                        } else {
                                          print(response.reasonPhrase);
                                          Get.showSnackbar(GetSnackBar(
                                            duration: Duration(seconds: 2),
                                            messageText: Text(
                                              'Comment not created',
                                              style: FontTextStyle
                                                  .kTine17BoldRoboto,
                                            ),
                                          ));
                                        }

                                        /* final uint8list =
                                  await VideoThumbnail.thumbnailData(
                                    video: widget.file.path,
                                    imageFormat: ImageFormat.JPEG,
                                    maxHeight: 250,
                                    maxWidth: 250,
                                    quality: 50,
                                  );
                                  Uint8List imageInUnit8List =
                                  uint8list!; // store unit8List image here ;
                                  final tempDir = await getTemporaryDirectory();
                                  File file = await File(
                                      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png')
                                      .create();
                                  file.writeAsBytesSync(imageInUnit8List);
                                  var a = await controller.videoInfo
                                      .getVideoInfo(widget.file.path);
                                  print('value get of video ???? $value');*/

                                        /*  controller.dataAddInFileAll(File(outputPath),
                                      file, a!.filesize, a.duration);*/
                                      });
                                },
                                child: Text("Post",
                                    style: TextStyle(
                                        color: ColorUtils.kTint, fontSize: 18)),
                              );
                            },
                          );
                  },
                )
              ],
            ),
            body: Builder(
              builder: (context) => Center(
                child: Container(
                  padding: EdgeInsets.only(bottom: 30.0),
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Visibility(
                        visible: _progressVisibility,
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.006,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.05,
                            vertical: Get.height * 0.006),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TrimEditor(
                              trimmer: _trimmer,
                              viewerHeight: 50.0,
                              viewerWidth: Get.width * 0.75,
                              maxVideoLength: Duration(seconds: 59),
                              onChangeStart: (value) {
                                _startValue = value;
                              },
                              onChangeEnd: (value) {
                                _endValue = value;
                              },
                              onChangePlaybackState: (value) {
                                setState(() {
                                  _isPlaying = value;
                                });
                              },
                            ),
                            SizedBox(
                              height: 50,
                              width: Get.width * 0.15,
                              child: IconButton(
                                icon: _isPlaying
                                    ? Icon(
                                        Icons.pause,
                                        size: 50.0,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.play_arrow,
                                        size: 50.0,
                                        color: Colors.white,
                                      ),
                                onPressed: () async {
                                  bool playbackState =
                                      await _trimmer.videPlaybackControl(
                                    startValue: _startValue,
                                    endValue: _endValue,
                                  );
                                  setState(() {
                                    _isPlaying = playbackState;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: VideoViewer(trimmer: _trimmer),
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      GetBuilder<AllCommentViewModel>(
                        builder: (controller) {
                          return Container(
                            height: Get.height * 0.068,
                            color: ColorUtils.kTint.withOpacity(0.2),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.height * 0.015),
                              child: TextField(
                                controller: captionController,
                                style: FontTextStyle.kWhite17W400Roboto,
                                decoration: InputDecoration(
                                  hintText: 'Add a caption.....',
                                  hintStyle: FontTextStyle.kWhite17W400Roboto,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
