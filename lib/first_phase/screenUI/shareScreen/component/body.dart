import 'dart:async';
import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:solarex/first_phase/Server/IntroducationAPI_ARRAY.dart';
import 'package:solarex/first_phase/apiModel/introducedAllContectsModel.dart';
import 'package:solarex/first_phase/screenUI/viewShareScreen/view_share_screen.dart';
import 'package:solarex/utils/constants.dart';
import 'package:solarex/utils/dialog_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../theme/style.dart';
import '../../../../utils/colors_app.dart';
import '../model/beanContacts.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class _BodyState extends State<Body> {
  List<Contact> duplicateItems = [];
  List<Contact> originalitems = [];

  List<beanContacts> duplicateItem = [];
  List<beanContacts> originalitem = <beanContacts>[];
  List<IntroducedAllContectsModel> introducedList = <IntroducedAllContectsModel>[];

  List<bool>? isChecked;
  int contactNo = 0;
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();

    refreshContacts();
  }

  addData() async {
    for (int i = 0; i < duplicateItems.length; i++) {
      var mobilenum = duplicateItems[i].phones!.toList();
      duplicateItem.add(beanContacts("", duplicateItems[i].displayName != null ? (duplicateItems[i].displayName!) : "Not available",
          mobilenum.length != 0 ? mobilenum[0].value.toString() : "Not available", false, false, false, false));
    }
    originalitem.addAll(duplicateItem);
  }

  Future<void> refreshContacts() async {
    var contacts = (await ContactsService.getContacts(withThumbnails: false));
    setState(() {
      duplicateItems = contacts;
      originalitems.addAll(duplicateItems);
      isChecked = List.generate(duplicateItems.length, (index) => false);
      addData();
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      List<beanContacts> dummySearchList = <beanContacts>[];
      dummySearchList.addAll(duplicateItem);
      print("duplicated items length ${duplicateItem.length.toString()}");
      if (query.isNotEmpty) {
        List<beanContacts> dummyListData = <beanContacts>[];
        dummySearchList.forEach((item) {
          if (item.name!.toLowerCase().contains(query.toLowerCase())) {
            dummyListData.add(item);
          }
        });

        originalitem.clear();
        originalitem.addAll(dummyListData);

        return;
      } else {
        print("duplicated items length ${duplicateItem.length.toString()}");
        originalitem.clear();
        originalitem.addAll(duplicateItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ConstantClass.fullHeight(context),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),

          Container(
              // width: 300,
              margin: const EdgeInsets.only(left: 14, right: 14),
              child: TextField(
                onChanged: (string) {
                  _debouncer.run(
                    () {
                      filterSearchResults(string);
                    },
                  );
                  // _waits(true);
                  // filterSearchResults(value);
                },
                style: textStrBtn,
                keyboardType: TextInputType.text,
                autofocus: false,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryDarkColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryDarkColor),
                  ),
                  fillColor: kPrimaryDarkColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryDarkColor),
                  ),
                  hintText: "Search",
                  hintStyle: textStrBtn,
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              )),
          // Container(
          //   margin: const EdgeInsets.symmetric(horizontal: 10),
          //   child: TextFormField(
          //     onChanged: (string) {
          //       _debouncer.run(
          //         () {
          //           filterSearchResults(string);
          //         },
          //       );
          //       // _waits(true);
          //       // filterSearchResults(value);
          //     },
          //     textAlign: TextAlign.start,
          //     decoration: const InputDecoration(
          //       enabledBorder: OutlineInputBorder(
          //         borderSide: BorderSide(color: kPrimaryDarkColor),
          //       ),
          //       focusedBorder: OutlineInputBorder(
          //         borderSide: BorderSide(color: kPrimaryDarkColor),
          //       ),
          //       fillColor: kPrimaryDarkColor,
          //       filled: true,
          //       border: OutlineInputBorder(
          //         borderSide: BorderSide(color: kPrimaryDarkColor),
          //       ),
          //       hintText: "Search",
          //       hintStyle: textStrBtn,
          //       isDense: true,
          //       contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
          //       prefixIcon: Icon(
          //         Icons.search,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              "Select Awesome people to recommend",
              textAlign: TextAlign.center,
              style: textLiteBlueDec,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          duplicateItem.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                  color: kPrimaryDarkColor,
                ))
              : Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: originalitem.length,
                    itemBuilder: (context, index) {
                      String name = originalitem[index].name != null ? (originalitem[index].name!) : "Not available";

                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFeeeeee),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: kPrimaryDarkColor,
                                ),

                                const SizedBox(
                                  width: 20,
                                ),

                                SizedBox(
                                  width: ConstantClass.fullWidth(context) * 0.60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      Text(
                                        originalitem[index].numbar,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                // contacts.isCheck
                                //     ?
                                SizedBox(
                                  height: 25,
                                  child: Checkbox(
                                      value: originalitem[index].isCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          originalitem[index].isCheck = value!;
                                          if (originalitem[index].isCheck == true) {
                                            contactNo++;
                                            ConstantClass.selectedContactList.add(originalitem[index]);
                                          } else {
                                            contactNo--;
                                            ConstantClass.selectedContactList.remove(originalitem[index]);
                                          }
                                        });
                                      }),
                                )
                                //     :
                                // Container(
                                //   margin: EdgeInsets.only(right: 10),
                                //   child: Text(
                                //     "introduce".toUpperCase(),
                                //     style:textBtnLiteBlue,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: ConstantClass.fullWidth(context),
                            height: 2,
                            color: const Color(0xFFdedede),
                          )
                        ],
                      );
                    },
                  ),
                ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size.fromHeight(40), // NEW
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                        //this right here
                        backgroundColor: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
                              width: ConstantClass.fullWidth(context),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Confirm Sharing Info',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  customLightText(
                                      'Share the contact information for ${contactNo} Contact with ${ConstantClass.repNumResponse!.repNumUserData!.firstName.toString().capitalize()} ${ConstantClass.repNumResponse!.repNumUserData!.lastName.toString().capitalize()}'),
                                  customDarkText('What information is shared?'),
                                  customLightText("Only a contact's first name, last name and phone number are shared"),
                                  customDarkText("How is that information shared?"),
                                  customLightText("it's uploaded to a private, secure system that allows your rep to access it."),
                                  customDarkText("How is that information used?"),
                                  customLightText("Solarex will not ever sell this information. It will be purged when it is no longer needed"),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _launchUrl("https://solarexpro.com/app-privacy-policy/");
                                    },
                                    child: const Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.blue,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "cancel".toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: kPrimaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            // for (var item in ConstantClass.selectedContactList) {
                                            //   introducedList.add(IntroducedAllContectsModel(
                                            //       repNumber: ConstantClass.repNumResponse?.repNumUserData?.repNumber,
                                            //       meetingNumber: ConstantClass.meetingNumber,
                                            //       message: '',
                                            //       mobNumber: item.numbar,
                                            //       username: item.name));
                                            // }

                                            // var streetsFromJson = getList()['streets'];
                                            // List<String> streetsList = List<String>.from(getList());
                                            // Map dataMap = {"introduce_data": getList()};

                                            _waits(true);
                                            introduceAPIARRAY(getList(), _sucessAPI, _error);

                                            //
                                            // Navigator.pop(context);
                                            // Navigator.pushNamed(context, ViewShareScreen.routeName);
                                          });
                                        },
                                        child: Text(
                                          'share ${contactNo} contact'.toUpperCase(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 13.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text(
                'share ${contactNo} contact'.toUpperCase(),
                style: textBtn,
              ),
            ),
          )
        ],
      ),
    );
  }

  _waits(bool value) {
    if (value) {
      showLoaderDialog(context);
    } else {
      Navigator.pop(context);
    }
  }

  _sucessAPI(String? message, String? status) {
    _waits(false);

    setState(() {
      Navigator.pop(context);
      Navigator.pushNamed(context, ViewShareScreen.routeName);
      print("MESSAGE===>$message");
      print("MESSAGE===>$status");
      //ConstantClass.selectedContactList.clear();
      //Navigator.pushNamed(context, ShareScreen.routeName);
    });
  }

  _error(String error) {
    _waits(false);
    print("API ERROR==$error");
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (_) => DialogWidget(
              title: "" + error,
              button1: 'Ok',
              onButton1Clicked: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              height: 150,
            ));
  }

  Future<void> _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) {
      throw 'Could not launch $_url';
    }
  }

  Widget customLightText(var text) {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          fontSize: 12.0,
        ),
      ),
    );
  }

  Widget customDarkText(var text) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          fontSize: 12.0,
        ),
      ),
    );
  }

  getList() {
    // var selectionData = [];

    for (var item in ConstantClass.selectedContactList) {
      introducedList.add(IntroducedAllContectsModel(
          repNumber: ConstantClass.repNumResponse?.repNumUserData?.repNumber,
          meetingNumber: ConstantClass.meetingNumber,
          message: '',
          mobNumber: item.numbar,
          username: item.name));
      // selectionData.add({
      //   'rep_number': ConstantClass.repNumResponse?.repNumUserData?.repNumber.toString(),
      //   'meeting_number': ConstantClass.meetingNumber.toString(),
      //   'message': '',
      //   'mob_number': item.numbar.toString(),
      //   'username': item.name.toString()
      // });
    }
    return introducedList;
  }
// Widget itemList(Contact contact, index) {
//   // String num = contact.phones != null ? (contact.phones!.first.value!) : "contact not available";
//   String name =
//       contact.displayName != null ? (contact.displayName!) : "Not available";
//   var mobilenum = contact.phones!.toList();
//
//   return Column(
//     children: [
//       Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         padding: const EdgeInsets.all(10),
//         decoration: const BoxDecoration(
//           color: Color(0xFFeeeeee),
//         ),
//         child: Row(
//           children: [
//             const Icon(
//               Icons.person,
//               color: kPrimaryDarkColor,
//             ),
//
//             const SizedBox(
//               width: 20,
//             ),
//
//             Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                     fontSize: 14.0,
//                   ),
//                 ),
//                 Text(
//                   mobilenum.length != 0
//                       ? mobilenum[0].value.toString()
//                       : "Not available",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: Colors.grey,
//                     fontSize: 12.0,
//                   ),
//                 ),
//               ],
//             ),
//
//             const Spacer(),
//
//             // contacts.isCheck
//             //     ?
//             SizedBox(
//               height: 25,
//               child: Checkbox(
//                   value: isChecked![index],
//                   onChanged: (value) {
//                     setState(() {
//                       isChecked![index] = value!;
//                       if (isChecked![index] == true) {
//                         contactNo++;
//
//                       } else {
//                         contactNo--;
//
//                       }
//
//
//                     });
//                   }),
//             )
//             //     :
//             // Container(
//             //   margin: EdgeInsets.only(right: 10),
//             //   child: Text(
//             //     "introduce".toUpperCase(),
//             //     style:textBtnLiteBlue,
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//       Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         width: ConstantClass.fullWidth(context),
//         height: 2,
//         color: const Color(0xFFdedede),
//       )
//     ],
//   );
// }
}
