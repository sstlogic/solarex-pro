class GoalSetModel {
  String? date;
  String? goal;

  GoalSetModel({this.date, this.goal});

  GoalSetModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    goal = json['goal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['goal'] = goal;
    return data;
  }
}

class SaveAllGoals {
  List<GoalSetModel>? data;

  SaveAllGoals({this.data});

  SaveAllGoals.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GoalSetModel>[];
      json['data'].forEach((v) {
        data!.add(GoalSetModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
