class AllNotesModel {
  String? status;
  String? message;
  List<AllNotesListItems>? allNotesList;

  AllNotesModel({this.status, this.message, this.allNotesList});

  AllNotesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['Data'] != null) {
      allNotesList = <AllNotesListItems>[];
      json['Data'].forEach((v) {
        allNotesList!.add(AllNotesListItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.allNotesList != null) {
      data['Data'] = this.allNotesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllNotesListItems {
  String? noteId;
  String? note;

  AllNotesListItems({this.noteId, this.note});

  AllNotesListItems.fromJson(Map<String, dynamic> json) {
    noteId = json['note_id'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note_id'] = noteId;
    data['note'] = note;
    return data;
  }
}