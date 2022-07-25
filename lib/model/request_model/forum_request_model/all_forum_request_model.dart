class AllForumRequestModel {
  String? userId;
  String? filter;

  AllForumRequestModel({this.userId, this.filter});

  AllForumRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    filter = json['filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['filter'] = this.filter;
    return data;
  }
}
