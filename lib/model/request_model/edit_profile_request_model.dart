class EditProfileRequestModel {
  String? fname;
  String? lname;
  String? username;
  String? email;
  String? weight;
  String? birthday;
  String? userId;

  EditProfileRequestModel(
      {this.fname,
      this.lname,
      this.username,
      this.email,
      this.weight,
      this.birthday,
      this.userId});

  EditProfileRequestModel.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    username = json['username'];
    email = json['email'];
    weight = json['weight'];
    birthday = json['birthday'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['username'] = this.username;
    data['email'] = this.email;
    data['weight'] = this.weight;
    data['birthday'] = this.birthday;
    data['user_id'] = this.userId;
    return data;
  }
}
