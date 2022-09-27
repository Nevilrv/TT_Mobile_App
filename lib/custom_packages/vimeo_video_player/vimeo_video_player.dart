import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tcm/custom_packages/vimeo_video_player/vimeo_controller.dart';

class VimeoVideoPlayer extends StatefulWidget {
  final String url;

  final List<SystemUiOverlay> systemUiOverlay;

  DeviceOrientation deviceOrientation;

  VimeoVideoPlayer({
    Key? key,
    required this.url,
    this.systemUiOverlay = const [SystemUiOverlay.top, SystemUiOverlay.bottom],
    this.deviceOrientation = DeviceOrientation.portraitUp,
  });
  @override
  _VimeoVideoPlayerState createState() => _VimeoVideoPlayerState();
}

class _VimeoVideoPlayerState extends State<VimeoVideoPlayer> {
  late FlickManager _flickManager;

  ValueNotifier<bool> isVimeoVideoLoaded = ValueNotifier(false);

  VimeoController _vimeoController = Get.put(VimeoController());

  bool get _isVimeoVideo {
    var regExp = RegExp(
      r"^((https?):\/\/)?(www.)?vimeo\.com\/([0-9]+).*$",
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(widget.url);
    if (match != null && match.groupCount >= 1) return true;
    return false;
  }

  @override
  void initState() {
    super.initState();

    if (_isVimeoVideo) {
      _videoPlayer();
    }
  }

  @override
  void dispose() {
    print('Dispose===========');
    // _vimeoController.videoPause();
    _vimeoController.videoDispose();
    _flickManager.dispose();
    _vimeoController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars
    super.dispose();
  }

  void _videoPlayer() {
    _getVimeoVideoConfigFromUrl(widget.url).then((value) {
      final progressiveList = value?.request?.files?.progressive;

      var vimeoMp4Video = '';

      if (progressiveList != null && progressiveList.isNotEmpty) {
        progressiveList.map((element) {
          if (element != null &&
              element.url != null &&
              element.url != '' &&
              vimeoMp4Video == '') {
            vimeoMp4Video = element.url ?? '';
          }
        }).toList();
        if (vimeoMp4Video.isEmpty || vimeoMp4Video == '') {
          showAlertDialog(context);
        }
      }

      // _videoPlayerController = VideoPlayerController.network(vimeoMp4Video);
      _vimeoController.videoUrl(url: vimeoMp4Video);
      _flickManager = FlickManager(
        videoPlayerController: _vimeoController.videoPlayerController,
        autoPlay: true,
      );

      isVimeoVideoLoaded.value = !isVimeoVideoLoaded.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isVimeoVideoLoaded,
      builder: (context, bool isVideo, child) => Container(
        child: isVideo
            ? FlickVideoPlayer(
                key: ObjectKey(_flickManager),
                flickManager: _flickManager,
                systemUIOverlay: widget.systemUiOverlay,
                preferredDeviceOrientation: [
                  widget.deviceOrientation,
                ],
                flickVideoWithControls: const FlickVideoWithControls(
                  videoFit: BoxFit.fitWidth,
                  controls: FlickPortraitControls(),
                ),
                flickVideoWithControlsFullscreen: const FlickVideoWithControls(
                  controls: FlickLandscapeControls(),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                  backgroundColor: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<VimeoVideoConfig?> _getVimeoVideoConfigFromUrl(
    String url, {
    bool trimWhitespaces = true,
  }) async {
    if (trimWhitespaces) url = url.trim();

    var vimeoVideoId = '';
    var videoIdGroup = 4;
    for (var exp in [
      RegExp(r"^((https?):\/\/)?(www.)?vimeo\.com\/([0-9]+).*$"),
    ]) {
      RegExpMatch? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        vimeoVideoId = match.group(videoIdGroup) ?? '';
      }
    }

    final response = await _getVimeoVideoConfig(vimeoVideoId: vimeoVideoId);
    return (response != null) ? response : null;
  }

  Future<VimeoVideoConfig?> _getVimeoVideoConfig({
    required String vimeoVideoId,
  }) async {
    try {
      dio.Response responseData = await Dio().get(
        'https://player.vimeo.com/video/$vimeoVideoId/config',
      );
      var vimeoVideo = VimeoVideoConfig.fromJson(responseData.data);
      return vimeoVideo;
    } on DioError catch (e) {
      // log('Dio Error : ', name: e.error.toString());
      return null;
    } on Exception catch (e) {
      // log('Error : ', name: e.toString());
      return null;
    }
  }
}

extension _ on _VimeoVideoPlayerState {
  showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content: const Text("Some thing wrong with this url"),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class VimeoVideoConfig {
  VimeoVideoConfig({
    this.request,
  });

  factory VimeoVideoConfig.fromJson(Map<String, dynamic> json) =>
      VimeoVideoConfig(
        request: VimeoRequest.fromJson(json["request"]),
      );

  VimeoRequest? request;
}

class VimeoRequest {
  VimeoRequest({
    this.files,
  });

  factory VimeoRequest.fromJson(Map<String, dynamic> json) => VimeoRequest(
        files: VimeoFiles.fromJson(json["files"]),
      );

  VimeoFiles? files;
}

class VimeoFiles {
  VimeoFiles({
    this.progressive,
  });

  factory VimeoFiles.fromJson(Map<String, dynamic> json) => VimeoFiles(
        progressive: List<VimeoProgressive>.from(
            json["progressive"].map((x) => VimeoProgressive.fromJson(x))),
      );

  List<VimeoProgressive?>? progressive;
}

class VimeoProgressive {
  VimeoProgressive({
    this.profile,
    this.width,
    this.mime,
    this.fps,
    this.url,
    this.cdn,
    this.quality,
    this.id,
    this.origin,
    this.height,
  });

  factory VimeoProgressive.fromJson(Map<String, dynamic> json) =>
      VimeoProgressive(
        profile: json["profile"],
        width: json["width"],
        mime: json["mime"],
        fps: json["fps"],
        url: json["url"],
        cdn: json["cdn"],
        quality: json["quality"],
        id: json["id"],
        origin: json["origin"],
        height: json["height"],
      );

  dynamic profile;
  int? width;
  String? mime;
  int? fps;
  String? url;
  String? cdn;
  String? quality;
  dynamic id;
  String? origin;
  int? height;
}
