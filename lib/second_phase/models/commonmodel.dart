class CommonModel {
  String? status;
  String? message;
  int? contactId;

  CommonModel({this.status, this.message, this.contactId});

  CommonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    contactId = json['contact_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['contact_id'] = contactId;
    return data;
  }
}
