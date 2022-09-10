class CustomHabitRequestModel {
  String? name;
  String? userId;

  CustomHabitRequestModel({this.name, this.userId});

  CustomHabitRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['user_id'] = this.userId;
    return data;
  }
}
