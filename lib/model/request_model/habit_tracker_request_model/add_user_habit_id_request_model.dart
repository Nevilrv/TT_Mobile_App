class AddUserHabitIdRequestModel {
  String? userId;
  String? habitIds;

  AddUserHabitIdRequestModel({this.userId, this.habitIds});

  AddUserHabitIdRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    habitIds = json['habit_ids'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['habit_ids'] = this.habitIds;
    return data;
  }
}
