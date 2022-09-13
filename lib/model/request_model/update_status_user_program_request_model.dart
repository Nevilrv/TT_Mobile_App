class UpdateStatusUserProgramRequestModel {
  String? userProgramDatesId;

  UpdateStatusUserProgramRequestModel({this.userProgramDatesId});

  UpdateStatusUserProgramRequestModel.fromJson(Map<String, dynamic> json) {
    userProgramDatesId = json['user_program_dates_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_program_dates_id'] = this.userProgramDatesId;
    return data;
  }
}
