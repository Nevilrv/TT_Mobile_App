import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:video_trimmer/video_trimmer.dart';

import '../../viewModel/forum_viewModel/add_forum_viewmodel.dart';

class CompressVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: ElevatedButton(
            child: Text("LOAD VIDEO"),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.video,
                allowCompression: false,
              );
              if (result != null) {
                File file = File(result.files.single.path!);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return TrimmerView(file);
                  }),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class TrimmerView extends StatefulWidget {
  final File file;

  TrimmerView(this.file);

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
    return Scaffold(
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
                  : TextButton(
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
                              final tempDir = await getTemporaryDirectory();
                              File file = await File(
                                      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.png')
                                  .create();
                              file.writeAsBytesSync(imageInUnit8List);
                              var a = await controller.videoInfo
                                  .getVideoInfo(widget.file.path);
                              print('value ???? $value');
                              controller.dataAddInFileAll(File(outputPath),
                                  file, a!.filesize, a.duration);
                              print('12122 ==== >>>> ${controller.filesAll}');
                              Get.back();
                            });
                      },
                      child: Text("Add",
                          style:
                              TextStyle(color: ColorUtils.kTint, fontSize: 18)),
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
                    bool playbackState = await _trimmer.videPlaybackControl(
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
    );
  }
}
