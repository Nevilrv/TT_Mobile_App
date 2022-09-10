class UserHabitTrackStatusRequestModel {
  String? userId;
  String? status;

  UserHabitTrackStatusRequestModel({this.userId, this.status});

  UserHabitTrackStatusRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['status'] = this.status;
    return data;
  }
}
