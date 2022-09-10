class LikeForumRequestModel {
  String? userId;
  String? postId;

  String? like;
  String? disLike;

  LikeForumRequestModel({this.userId, this.postId, this.disLike, this.like});

  LikeForumRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    postId = json['post_id'];
    like = json['like'];
    disLike = json['dislike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['like'] = this.like;
    data['dislike'] = this.disLike;

    return data;
  }
}
