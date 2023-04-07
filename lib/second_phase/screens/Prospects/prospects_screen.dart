import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solarex/first_phase/screenUI/shareScreen/component/body_old.dart';
import 'package:solarex/second_phase/controllers/prospective_controllers.dart';
import 'package:solarex/second_phase/models/prospective_listmodel.dart';
import 'package:solarex/second_phase/screens/Prospects/prospects_details.screen.dart';
import 'package:solarex/utils/loading_spinner.dart';
import 'package:solarex/utils/utils.dart';

import '../../../first_phase/screenUI/shareScreen/model/beanContacts.dart';
import '../../../theme/style.dart';
import '../../../utils/colors_app.dart';
import '../../../utils/constants.dart';

class ProspectsScreen extends StatefulWidget {
  const ProspectsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProspectsScreen> createState() => _ProspectsScreenState();
}

class _ProspectsScreenState extends State<ProspectsScreen> with WidgetsBindingObserver {
  final _debouncer = Debouncer();
  List<ProspectiveContectList> duplicateItems = [];
  List<ProspectiveContectList> originalitems = [];
  List<beanContacts> duplicateItem = [];
  List<beanContacts> originalitem = <beanContacts>[];
  List<bool>? isChecked;
  int contactNo = 0;
  var isAddtoPerspect = false;
  var agebuttonText = "30-64";
  var clickCounter = 0;
  var ageNotSelected = true;
  final prospectiveController = Get.put(ProspectiveController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    prospectiveController.getProspectiveList(userId: userId).then(
      (value) {
        duplicateItems = [];
        duplicateItem = [];
        originalitem = [];
        originalitems = [];
        duplicateItems = prospectiveController.prospectiveListModel.value.prospectiveContectList ?? [];
        originalitems.addAll(duplicateItems);
        isChecked = List.generate(duplicateItems.length, (index) => false);
        addData();
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void reassemble() {
    print('Call reassemble');
  }

  @override
  void activate() {
    print('Call reassemble');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  void onResumed() {
    print('Call onResume');
    // TODO: implement onResumed
  }

  void onPaused() {
    print('Call onPaused');
    // TODO: implement onPaused
  }

  void onInactive() {
    print('Call onInactive');
    // TODO: implement onInactive
  }

  void onDetached() {
    print('Call onDetached');
    // TODO: implement onDetached
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "Prospects",
          style: textHeading,
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
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
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(() => prospectiveController.loadingProspectiveList.isTrue
                  ? const Center(child: LoadingSpinner())
                  : (prospectiveController.prospectiveListModel.value.prospectiveContectList ?? []).isEmpty
                      ? const Center(
                          child: Text(
                          'List is Empty',
                          style: text18Black,
                        ))
                      : SingleChildScrollView(child: prospectiveList())),
            )
          ],
        ),
      ),
    );
  }

  @override
  void onResume() {
    print('Call On Resume');
  }

  Widget prospectiveList() {
    return
        // !isfetchFromAPI ?
        RefreshIndicator(
            color: Colors.white,
            onRefresh: () async {
              setState(() {
                prospectiveController.getProspectiveList(userId: userId).then(
                  (value) {
                    duplicateItems = [];
                    duplicateItem = [];
                    originalitem = [];
                    originalitems = [];
                    duplicateItems = prospectiveController.prospectiveListModel.value.prospectiveContectList ?? [];
                    originalitems.addAll(duplicateItems);
                    isChecked = List.generate(duplicateItems.length, (index) => false);
                    addData();
                  },
                );
              });
            },
            child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: Column(
                  children: [
                    ...originalitem.mapIndexed((int index, item) {
                      String name = originalitem[index].name != null ? (originalitem[index].name!) : "Not available";
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ProspectsDetailsScreen(
                                    contectId: originalitem[index].contectId,
                                  );
                                },
                              ),
                            );
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: ConstantClass.fullWidth(context),
                              // height: ConstantClass.fullHeight(context),
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
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: ConstantClass.fullWidth(context) * 0.80,
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
                                  ),
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
                        ),
                      );
                    }).toList(),
                  ],
                )
                // ListView.builder(
                //   shrinkWrap: true,
                //   // physics: const AlwaysScrollableScrollPhysics(),
                //   itemCount: originalitem.length,
                //   itemBuilder: (context, index) {
                //     String name = originalitem[index].name != null ? (originalitem[index].name!) : "Not available";
                //     return GestureDetector(
                //       onTap: () {
                //         setState(() {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) {
                //                 return ProspectsDetailsScreen(
                //                   contectId: originalitem[index].contectId,
                //                 );
                //               },
                //             ),
                //           );
                //         });
                //       },
                //       child: Column(
                //         children: [
                //           Container(
                //             width: ConstantClass.fullWidth(context),
                //             // height: ConstantClass.fullHeight(context),
                //             margin: const EdgeInsets.symmetric(horizontal: 10),
                //             padding: const EdgeInsets.all(10),
                //             decoration: const BoxDecoration(
                //               color: Color(0xFFeeeeee),
                //             ),
                //             child: Row(
                //               children: [
                //                 const Icon(
                //                   Icons.person,
                //                   color: kPrimaryDarkColor,
                //                 ),
                //                 const SizedBox(
                //                   width: 10,
                //                 ),
                //                 Expanded(
                //                   child: SizedBox(
                //                     width: ConstantClass.fullWidth(context) * 0.80,
                //                     child: Column(
                //                       mainAxisAlignment: MainAxisAlignment.start,
                //                       crossAxisAlignment: CrossAxisAlignment.start,
                //                       children: [
                //                         Text(
                //                           name,
                //                           style: const TextStyle(
                //                             fontWeight: FontWeight.w600,
                //                             color: Colors.black,
                //                             overflow: TextOverflow.ellipsis,
                //                             fontSize: 14.0,
                //                           ),
                //                         ),
                //                         Text(
                //                           originalitem[index].numbar,
                //                           style: const TextStyle(
                //                             fontWeight: FontWeight.w600,
                //                             color: Colors.grey,
                //                             overflow: TextOverflow.ellipsis,
                //                             fontSize: 12.0,
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.symmetric(horizontal: 10),
                //             width: ConstantClass.fullWidth(context),
                //             height: 2,
                //             color: const Color(0xFFdedede),
                //           )
                //         ],
                //       ),
                //     );
                //   },
                // ),
                ));
    // : _loadingView();
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
    String name = contact.displayName != null ? (contact.displayName!) : "Not available";
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
                    mobilenum.isNotEmpty ? mobilenum[0].value.toString() : "Not available",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              const Spacer(),
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

  // Future<void> refreshContacts() async {
  //   var contacts = (await ContactsService.getContacts(withThumbnails: false));
  //   setState(() {
  //     duplicateItems = contacts;
  //     originalitems.addAll(duplicateItems);
  //     isChecked = List.generate(duplicateItems.length, (index) => false);
  //     addData();
  //   });
  // }

  addData() async {
    for (int i = 0; i < duplicateItems.length; i++) {
      var mobilenum = duplicateItems[i].mobile;
      var contectId = duplicateItems[i].id;
      duplicateItem.add(beanContacts(contectId, duplicateItems[i].name != null ? (duplicateItems[i].name!) : "Not available",
          mobilenum!.isNotEmpty ? mobilenum.toString() : "Not available", false, false, false, false));
    }
    originalitem.addAll(duplicateItem);
    // setState(() {});
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
}
