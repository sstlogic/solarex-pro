class IntroducedAllContectsModel {
  String? meetingNumber;
  String? repNumber;
  String? username;
  String? mobNumber;
  String? message;

  IntroducedAllContectsModel({this.meetingNumber, this.repNumber, this.username, this.mobNumber, this.message});

  IntroducedAllContectsModel.fromJson(Map<String, dynamic> json) {
    meetingNumber = json['meeting_number'];
    repNumber = json['rep_number'];
    username = json['username'];
    mobNumber = json['mob_number'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['meeting_number'] = meetingNumber;
    data['rep_number'] = repNumber;
    data['username'] = username;
    data['mob_number'] = mobNumber;
    data['message'] = message;
    return data;
  }
}
