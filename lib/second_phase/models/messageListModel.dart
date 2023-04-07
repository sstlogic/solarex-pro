class MessageListModel {
  String? status;
  String? message;
  List<MessageListItem>? messageList;

  MessageListModel({this.status, this.message, this.messageList});

  MessageListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['response'] != null) {
      messageList = <MessageListItem>[];
      json['response'].forEach((v) {
        messageList!.add(MessageListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (messageList != null) {
      data['response'] = messageList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageListItem {
  String? id;
  String? mesgType;
  String? mesg;
  String? updateBy;
  String? insertBy;

  MessageListItem({this.id, this.mesgType, this.mesg, this.updateBy, this.insertBy});

  MessageListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mesgType = json['mesg_type'];
    mesg = json['mesg'];
    updateBy = json['update_by'];
    insertBy = json['insert_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mesg_type'] = mesgType;
    data['mesg'] = mesg;
    data['update_by'] = updateBy;
    data['insert_by'] = insertBy;
    return data;
  }
}

class MessageContainModel {
  String? status;
  String? message;
  String? response;

  MessageContainModel({this.status, this.message, this.response});

  MessageContainModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['response'] = this.response;
    return data;
  }
}