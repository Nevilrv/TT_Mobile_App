// class AddCommentRequestModel {
//   String? userId;
//   String? postId;
//
//   String? comment;
//
//   AddCommentRequestModel({
//     this.userId,
//     this.postId,
//     this.comment,
//   });
//
//   AddCommentRequestModel.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     postId = json['post_id'];
//     comment = json['comment'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_id'] = this.userId;
//     data['post_id'] = this.postId;
//     data['comment'] = this.comment;
//     return data;
//   }
// }

class AddCommentRequestModel {
  String? postId;
  String? userId;
  String? comment;
  String? image;
  String? type;
  String? caption;

  AddCommentRequestModel(
      {this.postId,
      this.userId,
      this.comment,
      this.image,
      this.type,
      this.caption});

  AddCommentRequestModel.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    userId = json['user_id'];
    comment = json['comment'];
    image = json['image[]'];
    type = json['type'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['image[]'] = this.image;
    data['type'] = this.type;
    data['caption'] = this.caption;
    return data;
  }
}
