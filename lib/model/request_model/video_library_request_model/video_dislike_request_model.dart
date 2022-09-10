class VideoDislikeRequestModel {
  String? videoId;

  VideoDislikeRequestModel({this.videoId});

  VideoDislikeRequestModel.fromJson(Map<String, dynamic> json) {
    videoId = json['video_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_id'] = this.videoId;
    return data;
  }
}
