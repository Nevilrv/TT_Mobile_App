class SearchForumRequestModel {
  String? title;
  String? userId;
  SearchForumRequestModel({this.title, this.userId});
  SearchForumRequestModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['user_id'] = this.userId;
    return data;
  }
}
