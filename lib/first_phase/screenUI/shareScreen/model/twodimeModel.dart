import 'package:contacts_service/contacts_service.dart';

class twoDimeModel{
  List<Contact>? contacts;
  List<bool>? isChecked;

  twoDimeModel(var originalitems, var isChecked){
    this.contacts = originalitems;
    this.isChecked = isChecked;
  }
}