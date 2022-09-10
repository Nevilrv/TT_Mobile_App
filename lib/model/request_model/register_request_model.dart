class RegisterRequestModel {
  String? fname;
  String? lname;
  String? dob;
  String? username;
  String? email;
  String? password;
  String? gender;
  String? phone;
  String? weight;
  String? experienceLevel;

  RegisterRequestModel(
      {this.fname,
      this.lname,
      this.dob,
      this.username,
      this.email,
      this.password,
      this.gender,
      this.phone,
      this.weight,
      this.experienceLevel});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    lname = json['birthday'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    phone = json['phone'];
    weight = json['weight'];
    experienceLevel = json['experience_level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['birthday'] = this.dob;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['phone'] = this.phone;
    data['weight'] = this.weight;
    data['experience_level'] = this.experienceLevel;
    return data;
  }
}
