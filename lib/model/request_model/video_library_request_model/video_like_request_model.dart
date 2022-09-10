class VideoLikeRequestModel {
  String? videoId;

  VideoLikeRequestModel({this.videoId});

  VideoLikeRequestModel.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    return data;
  }
}
