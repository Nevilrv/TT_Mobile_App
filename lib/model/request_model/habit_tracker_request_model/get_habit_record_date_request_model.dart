class GetHabitRecordDateRequestModel {
  String? userId;
  String? date;

  GetHabitRecordDateRequestModel({this.userId, this.date});

  GetHabitRecordDateRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['date'] = this.date;
    return data;
  }
}
