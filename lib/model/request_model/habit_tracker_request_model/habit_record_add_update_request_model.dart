class HabitRecordAddUpdateRequestModel {
  String? userId;
  String? habitIds;
  String? date;

  HabitRecordAddUpdateRequestModel({this.userId, this.habitIds, this.date});

  HabitRecordAddUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    habitIds = json['habit_ids'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['habit_ids'] = this.habitIds;
    data['date'] = this.date;
    return data;
  }
}
