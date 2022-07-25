class AddCommentRequestModel {
  String? userId;
  String? postId;

  String? comment;

  AddCommentRequestModel({
    this.userId,
    this.postId,
    this.comment,
  });

  AddCommentRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    postId = json['post_id'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['comment'] = this.comment;
    return data;
  }
}
