class EditPassRequestModel {
  String? userId;
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;

  EditPassRequestModel(
      {this.userId,
      this.currentPassword,
      this.newPassword,
      this.confirmPassword});

  EditPassRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    currentPassword = json['current_password'];
    newPassword = json['new_password'];
    confirmPassword = json['confirm_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['current_password'] = this.currentPassword;
    data['new_password'] = this.newPassword;
    data['confirm_password'] = this.confirmPassword;
    return data;
  }
}
