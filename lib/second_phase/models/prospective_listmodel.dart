class ProspectiveListModel {
  String? status;
  String? message;
  List<ProspectiveContectList>? prospectiveContectList;

  ProspectiveListModel({this.status, this.message, this.prospectiveContectList});

  ProspectiveListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['response'] != null) {
      prospectiveContectList = <ProspectiveContectList>[];
      json['response'].forEach((v) {
        prospectiveContectList!.add(ProspectiveContectList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (prospectiveContectList != null) {
      data['response'] = prospectiveContectList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProspectiveContectList {
  String? id;
  String? salesUserid;
  String? name;
  String? mobile;
  String? age;
  String? homeowner;
  String? married;
  String? hasCutco;
  String? boughtFromMe;
  String? updateBy;
  String? createdBy;

  ProspectiveContectList(
      {this.id,
        this.salesUserid,
        this.name,
        this.mobile,
        this.age,
        this.homeowner,
        this.married,
        this.hasCutco,
        this.boughtFromMe,
        this.updateBy,
        this.createdBy});

  ProspectiveContectList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salesUserid = json['sales_userid'];
    name = json['name'];
    mobile = json['mobile'];
    age = json['age'];
    homeowner = json['homeowner'];
    married = json['married'];
    hasCutco = json['has_cutco'];
    boughtFromMe = json['bought_from_me'];
    updateBy = json['update_by'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sales_userid'] = salesUserid;
    data['name'] = name;
    data['mobile'] = mobile;
    data['age'] = age;
    data['homeowner'] = homeowner;
    data['married'] = married;
    data['has_cutco'] = hasCutco;
    data['bought_from_me'] = boughtFromMe;
    data['update_by'] = updateBy;
    data['created_by'] = createdBy;
    return data;
  }
}