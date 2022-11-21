class SubscriptionRequestModel {
  String? userId;
  String? startDate;
  String? endDate;
  String? currentPlan;

  SubscriptionRequestModel(
      {this.userId, this.startDate, this.endDate, this.currentPlan});

  SubscriptionRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    currentPlan = json['current_plan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['current_plan'] = this.currentPlan;
    return data;
  }
}
