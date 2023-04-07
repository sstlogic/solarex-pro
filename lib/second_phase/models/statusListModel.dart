class StatusListModel {
  String? status;
  String? message;
  List<ListItems>? statusList;

  StatusListModel({this.status, this.message, this.statusList});

  StatusListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['response'] != null) {
      statusList = <ListItems>[];
      json['response'].forEach((v) {
        statusList!.add(ListItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (statusList != null) {
      data['response'] = statusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListItems {
  String? id;
  String? status;
  String? updateBy;
  String? insertBy;
  bool? isSelected;

  ListItems({this.id, this.status, this.updateBy, this.insertBy,this.isSelected=false});

  ListItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    updateBy = json['update_by'];
    insertBy = json['insert_by'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['update_by'] = updateBy;
    data['insert_by'] = insertBy;
    return data;
  }
}