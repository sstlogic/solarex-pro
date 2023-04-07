class MemberDetailsModel {
  String? status;
  String? message;
  Data? data;

  MemberDetailsModel({this.status, this.message, this.data});

  MemberDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? salesUserid;
  String? referredBy;
  String? mobile;
  String? firstName;
  String? lastName;
  String? email;
  String? insertBy;

  Data(
      {this.id,
        this.salesUserid,
        this.referredBy,
        this.mobile,
        this.firstName,
        this.lastName,
        this.email,
        this.insertBy});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesUserid = json['sales_userid'];
    referredBy = json['referred_by'];
    mobile = json['mobile'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    insertBy = json['insert_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sales_userid'] = salesUserid;
    data['referred_by'] = referredBy;
    data['mobile'] = mobile;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['insert_by'] = insertBy;
    return data;
  }
}