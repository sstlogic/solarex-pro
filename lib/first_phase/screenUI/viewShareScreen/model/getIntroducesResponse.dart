class GetIntroducesResponse {
  String? status;
  String? message;
  List<getIntroducesContectList>? mGetIntroducesContectList;

  GetIntroducesResponse({this.status, this.message, this.mGetIntroducesContectList});

  GetIntroducesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['response'] != null) {
      mGetIntroducesContectList = <getIntroducesContectList>[];
      json['response'].forEach((v) {
        mGetIntroducesContectList!.add(getIntroducesContectList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (mGetIntroducesContectList != null) {
      data['response'] = mGetIntroducesContectList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class getIntroducesContectList {
  String? id;
  String? repNumber;
  String? meetingNumber;
  String? username;
  String? mobNumber;
  String? message;
  String? dg;
  String? d;
  String? s;
  String? cpo;
  String? recos;
  String? image;
  String? inserted;

  getIntroducesContectList(
      {this.id,
      this.repNumber,
      this.meetingNumber,
      this.username,
      this.mobNumber,
      this.message,
      this.dg,
      this.d,
      this.s,
      this.cpo,
      this.recos,
      this.image,
      this.inserted});

  getIntroducesContectList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    repNumber = json['rep_number'];
    meetingNumber = json['meeting_number'];
    username = json['username'];
    mobNumber = json['mob_number'];
    message = json['message'];
    dg = json['dg'];
    d = json['d'];
    s = json['s'];
    cpo = json['cpo'];
    recos = json['recos'];
    image = json['image'];
    inserted = json['inserted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rep_number'] = repNumber;
    data['meeting_number'] = meetingNumber;
    data['username'] = username;
    data['mob_number'] = mobNumber;
    data['message'] = message;
    data['dg'] = dg;
    data['d'] = d;
    data['s'] = s;
    data['cpo'] = cpo;
    data['recos'] = recos;
    data['image'] = image;
    data['inserted'] = inserted;
    return data;
  }
}
