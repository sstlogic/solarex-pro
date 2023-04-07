class GetGoalsDataModel {
  String? status;
  String? message;
  List<AllGoalList>? allGoalList;

  GetGoalsDataModel({this.status, this.message, this.allGoalList});

  GetGoalsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['Data'] != null) {
      allGoalList = <AllGoalList>[];
      json['Data'].forEach((v) {
        allGoalList!.add(AllGoalList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (allGoalList != null) {
      data['Data'] = allGoalList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllGoalList {
  String? id;
  String? userId;
  String? date;
  String? goal;

  AllGoalList({this.id, this.userId, this.date, this.goal});

  AllGoalList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    date = json['date'];
    goal = json['goal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['date'] = date;
    data['goal'] = goal;
    return data;
  }
}
