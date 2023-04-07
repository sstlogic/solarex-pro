class ReferralUserListModel {
  String? status;
  String? message;
  List<ReferralUserListItem>? referralUserList;

  ReferralUserListModel({this.status, this.message, this.referralUserList});

  ReferralUserListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['Data'] != null) {
      referralUserList = <ReferralUserListItem>[];
      json['Data'].forEach((v) {
        referralUserList!.add(ReferralUserListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (referralUserList != null) {
      data['Data'] = referralUserList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReferralUserListItem {
  String? id;
  String? salesUserid;
  String? contactId;
  String? meetingCode;
  String? name;
  String? mobile;
  String? createdBy;

  ReferralUserListItem({this.id, this.salesUserid, this.contactId, this.meetingCode, this.name, this.mobile, this.createdBy});

  ReferralUserListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesUserid = json['sales_userid'];
    contactId = json['contact_id'];
    meetingCode = json['meeting_code'];
    name = json['name'];
    mobile = json['mobile'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sales_userid'] = salesUserid;
    data['contact_id'] = contactId;
    data['meeting_code'] = meetingCode;
    data['name'] = name;
    data['mobile'] = mobile;
    data['created_by'] = createdBy;
    return data;
  }
}
