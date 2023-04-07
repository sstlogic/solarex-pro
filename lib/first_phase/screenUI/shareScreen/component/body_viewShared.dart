import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:solarex/utils/constants.dart';
import '../../../../theme/style.dart';

import '../../../../utils/colors_app.dart';

class Body_viewSharedState extends StatefulWidget {
  const Body_viewSharedState({Key? key}) : super(key: key);

  @override
  _Body_viewSharedStateState createState() => _Body_viewSharedStateState();
}

class _Body_viewSharedStateState extends State<Body_viewSharedState> {

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: ConstantClass.fullHeight(context),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),

          ConstantClass.selectedContactList == null
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: ConstantClass.selectedContactList.length,
              itemBuilder: (context, index) {
                String name = ConstantClass.selectedContactList[index].name != null
                    ? (ConstantClass.selectedContactList[index].name!)
                    : "Not available";
                // var mobilenum = duplicateItems[index].phones!.toList();

                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
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
                          //
                          const SizedBox(
                            width: 20,
                          ),

                          Expanded(
                            // width: ConstantClass.fullWidth(context) * 0.60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                                // Text(
                                //   mobilenum.length != 0
                                //       ? mobilenum[0].value.toString()
                                //       : "Not available",
                                //   style: const TextStyle(
                                //     fontWeight: FontWeight.w600,
                                //     color: Colors.grey,
                                //     overflow: TextOverflow.ellipsis,
                                //     fontSize: 12.0,
                                //   ),
                                // ),
                              ],
                            ),
                          ),



                          // contacts.isCheck
                          //     ?

                          //     :
                          Container(
                            // margin: EdgeInsets.only(right: 10),
                            child: Text(
                              "introduce".toUpperCase(),
                              style:textBtnLiteBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6,)
                    // Container(
                    //   margin: const EdgeInsets.symmetric(horizontal: 10),
                    //   width: ConstantClass.fullWidth(context),
                    //   height: 2,
                    //   color: const Color(0xFFdedede),
                    // )
                  ],
                );
              },
            ),
            // ListView.builder(
            //     itemCount: duplicateItems.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       String name = duplicateItems[index].displayName != null ? (duplicateItems[index].displayName!) : "Not available";
            //       var mobilenum = duplicateItems[index].phones!.toList();
            //       return Column(
            //         children: [
            //
            //           Container(
            //             margin: const EdgeInsets.symmetric(horizontal: 10),
            //             padding: const EdgeInsets.all(10),
            //             decoration: const BoxDecoration(
            //               color: Color(0xFFeeeeee),
            //             ),
            //             child: Row(
            //               children: [
            //
            //                 const Icon(Icons.person, color: kPrimaryDarkColor,),
            //
            //                 const SizedBox(width: 20,),
            //
            //                 SizedBox(
            //                   width: ConstantClass.fullWidth(context) * 0.60,
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.start,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //
            //                       Text(
            //                         name,
            //                         style: const TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                           color:Colors.black,
            //                           overflow: TextOverflow.ellipsis,
            //                           fontSize: 14.0,
            //                         ),
            //                       ),
            //
            //                       Text(
            //                         mobilenum.length != 0 ? mobilenum[0].value.toString() : "Not available",
            //                         style: const TextStyle(
            //                           fontWeight: FontWeight.w600,
            //                           color:Colors.grey,
            //                           overflow: TextOverflow.ellipsis,
            //                           fontSize: 12.0,
            //                         ),
            //                       ),
            //
            //                     ],
            //                   ),
            //                 ),
            //
            //                 const Spacer(),
            //
            //                 // contacts.isCheck
            //                 //     ?
            //                 SizedBox(
            //                   height: 25,
            //                   child: Checkbox(
            //                       value: isChecked![index],
            //                       onChanged: (value){
            //                         setState(() {
            //                           isChecked![index] = value!;
            //                           if(isChecked![index] == true){
            //                             contactNo++;
            //                           }else {
            //                             contactNo--;
            //                           }
            //                         });
            //                       }
            //                   ),
            //                 )
            //                 //     :
            //                 // Container(
            //                 //   margin: EdgeInsets.only(right: 10),
            //                 //   child: Text(
            //                 //     "introduce".toUpperCase(),
            //                 //     style:textBtnLiteBlue,
            //                 //   ),
            //                 // ),
            //
            //               ],
            //             ),
            //           ),
            //
            //           Container(
            //             margin: const EdgeInsets.symmetric(horizontal: 10),
            //             width: ConstantClass.fullWidth(context),
            //             height: 2,
            //             color: const Color(0xFFdedede),
            //           )
            //
            //         ],
            //       );
            //    },
            // ),
          ),

        ],
      ),
    );

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

  Widget itemList(Contact contact, index) {
    // String num = contact.phones != null ? (contact.phones!.first.value!) : "contact not available";
    String name =
        contact.displayName != null ? (contact.displayName!) : "Not available";
    var mobilenum = contact.phones!.toList();

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

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    mobilenum.length != 0
                        ? mobilenum[0].value.toString()
                        : "Not available",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // contacts.isCheck
              //     ?

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
  }
}
