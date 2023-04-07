class TeamFriendListModel {
  String? status;
  String? message;
  List<TeamFriendsItem>? teamFriendsList;

  TeamFriendListModel({this.status, this.message, this.teamFriendsList});

  TeamFriendListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['Data'] != null) {
      teamFriendsList = <TeamFriendsItem>[];
      json['Data'].forEach((v) {
        teamFriendsList!.add(TeamFriendsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (teamFriendsList != null) {
      data['Data'] = teamFriendsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeamFriendsItem {
  String? memberId;
  String? referredBy;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? email;
  bool? isCheck;
  TeamFriendsItem({this.memberId, this.referredBy, this.firstName, this.lastName, this.mobileNumber, this.email, this.isCheck = false});

  TeamFriendsItem.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    referredBy = json['referred_by'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['member_id'] = memberId;
    data['referred_by'] = referredBy;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['mobile'] = mobileNumber;
    data['email'] = email;
    return data;
  }
}
