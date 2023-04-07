// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:solarex/first_phase/screenUI/viewShareScreen/model/getIntroducesResponse.dart';
// import 'package:solarex/first_phase/Server/getIntroducesList.dart';
// import 'package:solarex/utils/constants.dart';
// import '../../../../theme/style.dart';
// import 'package:solarex/first_phase/screenUI/introductionScreen/introduction_screen.dart';
// import 'package:solarex/first_phase/screenUI/model/beanDumpContacts.dart';
//
// import '../../../../utils/colors_app.dart';
// import '../../../../utils/dialog_widget.dart';
//
// class Body extends StatefulWidget {
//   Body({Key? key}) : super(key: key);
//
//   @override
//   _BodyState createState() => _BodyState();
// }
//
// class _BodyState extends State<Body> {
//   var isApiCalled = true;
//
//   @override
//   Widget build(BuildContext context) {
//     if (isApiCalled == true) {
//       isApiCalled == false;
//       _waits(true);
//       getIntroducesList(ConstantClass.meetingNumber, ConstantClass.repNumber, sucessAPI, _error);
//     }
//
//     return SizedBox(
//       height: ConstantClass.fullHeight(context),
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           ConstantClass.selectedContactList.isEmpty
//               ? const Expanded(
//                   child: Padding(
//                   padding: EdgeInsets.all(10),
//                   child: Center(
//                       child: Text(
//                     "No Any Contact Selected.",
//                     style: textNormal,
//                     textAlign: TextAlign.center,
//                   )),
//                 ))
//               : Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: ConstantClass.selectedContactList.length,
//                     itemBuilder: (context, index) {
//                       String name =
//                           ConstantClass.selectedContactList[index].name != null ? (ConstantClass.selectedContactList[index].name!) : "Not available";
//
//                       return Column(
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(horizontal: 8),
//                             padding: const EdgeInsets.all(10),
//                             decoration: const BoxDecoration(
//                               color: Color(0xFFeeeeee),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.person,
//                                   color: kPrimaryDarkColor,
//                                 ),
//                                 //
//                                 const SizedBox(
//                                   width: 20,
//                                 ),
//
//                                 Expanded(
//                                   // width: ConstantClass.fullWidth(context) * 0.60,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         name,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.black,
//                                           overflow: TextOverflow.ellipsis,
//                                           fontSize: 14.0,
//                                         ),
//                                       ),
//                                       Text(
//                                         ConstantClass.selectedContactList[index].numbar,
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.grey,
//                                           overflow: TextOverflow.ellipsis,
//                                           fontSize: 12.0,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 !ConstantClass.selectedContactList[index].isIntroduced
//                                     ? InkWell(
//                                         onTap: () {
//                                           setState(() {
//                                             ConstantClass.beanDumpContacts12 =
//                                                 beanDumpContacts(name, ConstantClass.selectedContactList[index].numbar);
//                                           });
//                                           Navigator.pushNamed(context, IntroductionScreen.routeName);
//                                         },
//                                         child: Text(
//                                           "introduce".toUpperCase(),
//                                           style: textBtnLiteBlue,
//                                           textAlign: TextAlign.start,
//                                         ),
//                                       )
//                                     : Text(
//                                         "introduced".toUpperCase(),
//                                         style: textBtngrey,
//                                         textAlign: TextAlign.start,
//                                       ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             height: 6,
//                           )
//                           // Container(
//                           //   margin: const EdgeInsets.symmetric(horizontal: 10),
//                           //   width: ConstantClass.fullWidth(context),
//                           //   height: 2,
//                           //   color: const Color(0xFFdedede),
//                           // )
//                         ],
//                       );
//                     },
//                   ),
//                   // ListView.builder(
//                   //     itemCount: duplicateItems.length,
//                   //     itemBuilder: (BuildContext context, int index) {
//                   //       String name = duplicateItems[index].displayName != null ? (duplicateItems[index].displayName!) : "Not available";
//                   //       var mobilenum = duplicateItems[index].phones!.toList();
//                   //       return Column(
//                   //         children: [
//                   //
//                   //           Container(
//                   //             margin: const EdgeInsets.symmetric(horizontal: 10),
//                   //             padding: const EdgeInsets.all(10),
//                   //             decoration: const BoxDecoration(
//                   //               color: Color(0xFFeeeeee),
//                   //             ),
//                   //             child: Row(
//                   //               children: [
//                   //
//                   //                 const Icon(Icons.person, color: kPrimaryDarkColor,),
//                   //
//                   //                 const SizedBox(width: 20,),
//                   //
//                   //                 SizedBox(
//                   //                   width: ConstantClass.fullWidth(context) * 0.60,
//                   //                   child: Column(
//                   //                     mainAxisAlignment: MainAxisAlignment.start,
//                   //                     crossAxisAlignment: CrossAxisAlignment.start,
//                   //                     children: [
//                   //
//                   //                       Text(
//                   //                         name,
//                   //                         style: const TextStyle(
//                   //                           fontWeight: FontWeight.w600,
//                   //                           color:Colors.black,
//                   //                           overflow: TextOverflow.ellipsis,
//                   //                           fontSize: 14.0,
//                   //                         ),
//                   //                       ),
//                   //
//                   //                       Text(
//                   //                         mobilenum.length != 0 ? mobilenum[0].value.toString() : "Not available",
//                   //                         style: const TextStyle(
//                   //                           fontWeight: FontWeight.w600,
//                   //                           color:Colors.grey,
//                   //                           overflow: TextOverflow.ellipsis,
//                   //                           fontSize: 12.0,
//                   //                         ),
//                   //                       ),
//                   //
//                   //                     ],
//                   //                   ),
//                   //                 ),
//                   //
//                   //                 const Spacer(),
//                   //
//                   //                 // contacts.isCheck
//                   //                 //     ?
//                   //                 SizedBox(
//                   //                   height: 25,
//                   //                   child: Checkbox(
//                   //                       value: isChecked![index],
//                   //                       onChanged: (value){
//                   //                         setState(() {
//                   //                           isChecked![index] = value!;
//                   //                           if(isChecked![index] == true){
//                   //                             contactNo++;
//                   //                           }else {
//                   //                             contactNo--;
//                   //                           }
//                   //                         });
//                   //                       }
//                   //                   ),
//                   //                 )
//                   //                 //     :
//                   //                 // Container(
//                   //                 //   margin: EdgeInsets.only(right: 10),
//                   //                 //   child: Text(
//                   //                 //     "introduce".toUpperCase(),
//                   //                 //     style:textBtnLiteBlue,
//                   //                 //   ),
//                   //                 // ),
//                   //
//                   //               ],
//                   //             ),
//                   //           ),
//                   //
//                   //           Container(
//                   //             margin: const EdgeInsets.symmetric(horizontal: 10),
//                   //             width: ConstantClass.fullWidth(context),
//                   //             height: 2,
//                   //             color: const Color(0xFFdedede),
//                   //           )
//                   //
//                   //         ],
//                   //       );
//                   //    },
//                   // ),
//                 ),
//         ],
//       ),
//     );
//   }
//
//   Widget customLightText(var text) {
//     return Container(
//       margin: const EdgeInsets.only(top: 1),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontWeight: FontWeight.w500,
//           color: Colors.grey,
//           fontSize: 12.0,
//         ),
//       ),
//     );
//   }
//
//   Widget customDarkText(var text) {
//     return Container(
//       margin: const EdgeInsets.only(top: 10),
//       child: Text(
//         text,
//         style: const TextStyle(
//           fontWeight: FontWeight.w600,
//           color: Colors.grey,
//           fontSize: 12.0,
//         ),
//       ),
//     );
//   }
//
//   Widget itemList(Contact contact, index) {
//     // String num = contact.phones != null ? (contact.phones!.first.value!) : "contact not available";
//     String name = contact.displayName != null ? (contact.displayName!) : "Not available";
//     var mobilenum = contact.phones!.toList();
//
//     return Column(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           padding: const EdgeInsets.all(10),
//           decoration: const BoxDecoration(
//             color: Color(0xFFeeeeee),
//           ),
//           child: Row(
//             children: [
//               const Icon(
//                 Icons.person,
//                 color: kPrimaryDarkColor,
//               ),
//
//               const SizedBox(
//                 width: 20,
//               ),
//
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                       fontSize: 14.0,
//                     ),
//                   ),
//                   Text(
//                     mobilenum.length != 0 ? mobilenum[0].value.toString() : "Not available",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                       fontSize: 12.0,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const Spacer(),
//
//               // contacts.isCheck
//               //     ?
//
//               //     :
//               // Container(
//               //   margin: EdgeInsets.only(right: 10),
//               //   child: Text(
//               //     "introduce".toUpperCase(),
//               //     style:textBtnLiteBlue,
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           width: ConstantClass.fullWidth(context),
//           height: 2,
//           color: const Color(0xFFdedede),
//         )
//       ],
//     );
//   }
//
//   _waits(bool value) {
//     if (value) {
//       showLoaderDialog(context);
//     } else {
//       Navigator.pop(context);
//     }
//   }
//
//   sucessAPI(String? message, String? status, List<getIntroducesContectList>? mGetIntroducesContectList) {
//     _waits(false);
//     setState(() {
//       for (int i = 0; i < ConstantClass.selectedContactList.length; i++) {
//         if (ConstantClass.selectedContactList[i].numbar.toString().startsWith("+")) {
//           ConstantClass.selectedContactList[i].numbar = ConstantClass.selectedContactList[i].numbar.toString().substring(1).replaceAll(' ', '');
//         } else if (!ConstantClass.selectedContactList[i].numbar.toString().startsWith("91")) {
//           ConstantClass.selectedContactList[i].numbar = "91" + ConstantClass.selectedContactList[i].numbar.toString().replaceAll(' ', '');
//         }
//
//         var matchElements = findElementsUsingLoop(mGetIntroducesContectList!, ConstantClass.selectedContactList[i].numbar);
//         if (matchElements.isNotEmpty) {
//           ConstantClass.selectedContactList[i].isIntroduced = true;
//         }
//       }
//     });
//   }
//
//   String findElementsUsingLoop(List<getIntroducesContectList> people, String personName) {
//     for (var i = 0; i < people.length; i++) {
//       if (people[i].mobNumber == personName) {
//         return people[i].mobNumber.toString();
//       }
//     }
//     return "";
//   }
//
//   _error(String error) {
//     _waits(false);
//
//     showDialog(
//         context: context,
//         barrierColor: Colors.black.withOpacity(0.8),
//         builder: (_) => DialogWidget(
//               title: "" + error,
//               button1: 'Ok',
//               onButton1Clicked: () {
//                 Navigator.of(context, rootNavigator: true).pop();
//               },
//               height: 150,
//             ));
//   }
// }
