class GetProfileModel {
  String? status;
  String? message;
  Data? data;

  GetProfileModel({this.status, this.message, this.data});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? firstName;
  String? lastName;
  String? phone;
  String? repNumber;
  String? lifetimeReferral;
  String? mobile;
  String? email;
  String? userPic;
  String? intro_en;
  String? intro_es;
  String? intro_fr;

  Data(
      {this.firstName,
        this.lastName,
        this.phone,
        this.repNumber,
        this.lifetimeReferral,
        this.mobile,
        this.email,
        this.userPic,
        this.intro_en,
        this.intro_es,
        this.intro_fr,

      });

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    repNumber = json['rep_number'];
    lifetimeReferral = json['lifetime_referral'];
    mobile = json['mobile'];
    email = json['email'];
    userPic = json['user_pic'];
    intro_en = json['intro_en'];
    intro_es = json['intro_es'];
    intro_fr = json['intro_fr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['rep_number'] = repNumber;
    data['lifetime_referral'] = lifetimeReferral;
    data['mobile'] = mobile;
    data['email'] = email;
    data['user_pic'] = userPic;
    data['intro_en'] = intro_en;
    data['intro_es'] = intro_es;
    data['intro_fr'] = intro_fr;
    return data;
  }
}