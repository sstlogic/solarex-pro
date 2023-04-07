// class NotSubmitedMemberList {
//   String? status;
//   String? message;
//   List<SelectedContactMember>? cList;
//
//   NotSubmitedMemberList({this.status, this.message, this.cList});
//
//   NotSubmitedMemberList.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//
//     cList = json['Data'] != null ? SelectedContactMember.fromJson(json['Data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (cList != null) {
//       data['Data'] = cList!.toJson();
//     }
//     return data;
//   }
// }

class NotSubmitedMemberList {
  String? status;
  String? message;
  List<SelectedContactMember>? notSubmitedList;

  NotSubmitedMemberList({this.status, this.message, this.notSubmitedList});

  NotSubmitedMemberList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['Data'] != null) {
      notSubmitedList = <SelectedContactMember>[];
      json['Data'].forEach((v) {
        notSubmitedList!.add(SelectedContactMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (notSubmitedList != null) {
      data['Data'] = notSubmitedList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectedContactMember {
  String? firstName;
  String? lastName;
  String? mobile;
  String? referredBy;
  String? email;
  bool? isCheck;
  SelectedContactMember({this.firstName, this.lastName, this.mobile, this.referredBy, this.email, this.isCheck});

  SelectedContactMember.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    referredBy = json['referred_by'];
    // isCheck = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['mobile'] = mobile;
    data['email'] = email;
    data['referred_by'] = referredBy;
    // data['isCheck'] = isCheck;
    return data;
  }
}
