class AddForumRequestModel {
  String? userId;
  String? tagId;
  String? title;
  String? description;

  AddForumRequestModel({this.userId, this.tagId, this.title, this.description});

  AddForumRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    tagId = json['tag_id'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['tag_id'] = this.tagId;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}
