// ignore_for_file: file_names, must_be_immutable, use_key_in_widget_constructors, avoid_print
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/archivecontroller.dart';
// import 'package:welcom/controller/drawercontroller.dart';
import 'package:welcom/model/sqlitedb2.dart';
import 'package:welcom/view/adduser.dart';
// import 'package:welcom/view/sidebar.dart';
import 'package:welcom/view/editUser.dart';
// import 'package:welcom/widget/navigatorRail.dart';
// import 'package:welcom/view/home.dart';

class Archives extends GetView<ArchiveController> {
  Archives({super.key});
  SqlDB sqldb = SqlDB();
  TextEditingController teSeach = TextEditingController();
  // NavigationController controller1 = Get.put(NavigationController());
  ArchiveController archivecontroller = Get.put(ArchiveController());
  var scaffoldkey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // key: scaffoldkey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(() => AddUser());
          }),
      body: Row(children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  onChanged: (value) {
                    if (value == '') {
                      archivecontroller.users.clear();
                      archivecontroller.readData();
                      // Get.to(() => Archives());
                    }
                  },
                  controller: teSeach,
                  decoration: InputDecoration(
                      hintText: 'Search...',
                      labelText: 'Search',
                      prefixIcon: TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            archivecontroller.filter(teSeach.text);
                          },
                          child: const Icon(Icons.search)),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      )),
                ),
              ),
              Obx(
                () => Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      for (var user in archivecontroller.users)
                        SizedBox(
                          child: Card(
                            elevation: 9,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: ListTile(
                              leading: Image.file(
                                File('${user?['photo']}'),
                              ),
                              title: Container(
                                  padding: const EdgeInsets.all(10),
                                  //margin: EdgeInsets.all(10),
                                  child: Text(
                                    '${user?['username']}',
                                    style: const TextStyle(fontSize: 10),
                                  )),
                              subtitle: Column(children: [
                                Text(
                                  '${user?['email']}',
                                )
                              ]),
                              trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await archivecontroller
                                              .deleteuser(user['id']);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          Get.to(Editarchive(), arguments: {
                                            "id": user['id'],
                                            "username":
                                                user['username'].toString(),
                                            "email": user['email'].toString(),
                                            "pass": user['pass'].toString(),
                                            "photo": user['photo'].toString(),
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.update,
                                          color: Colors.black,
                                        )),
                                  ]),
                            ),
                          ),
                        )
                    ],
                  ),

                  // child: ListView.builder(
                  //   itemCount: archivecontroller.users.length,
                  //   shrinkWrap: true,
                  //   itemBuilder: (context,i) {
                  //     return Container(
                  //       padding: const EdgeInsets.symmetric(horizontal: 10),
                  //       // height: 150,
                  //       child: Card(
                  //         elevation: 9,
                  //         shape: const RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.all(Radius.circular(30)),
                  //         ),
                  //         child: ListTile(
                  //           dense: false,
                  //           leading: Image.file(
                  //             File('${archivecontroller.users[i]['photo']}'),
                  //           ),
                  //           title: Obx(
                  //             () => Text(
                  //               "${archivecontroller.users[i]?['username']}",
                  //               style: const TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 20),
                  //             ),
                  //           ),
                  //           subtitle: Column(children: [
                  //             Text(
                  //               "${archivecontroller.users.forEach((element) { })}",
                  //               style: const TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 16),
                  //             ),
                  //             Text(
                  //               "${archivecontroller.users[i]['email']}",
                  //               style: const TextStyle(
                  //                   fontWeight: FontWeight.bold, fontSize: 16),
                  //             ),
                  //           ]),
                  //           trailing:
                  //               Row(mainAxisSize: MainAxisSize.min, children: [
                  //             IconButton(
                  //                 onPressed: () async {
                  //                   await archivecontroller.deleteuser(
                  //                       archivecontroller.users[i]['id']);
                  //                 },
                  //                 icon: const Icon(
                  //                   Icons.delete,
                  //                   color: Colors.red,
                  //                 )),
                  //             IconButton(
                  //                 onPressed: () async {
                  //                   Get.to(Editarchive(), arguments: {
                  //                     "id": archivecontroller.users[i]['id'],
                  //                     "username": archivecontroller.users[i]
                  //                         ['username'],
                  //                     "email": archivecontroller.users[i]
                  //                         ['email'],
                  //                     "pass": archivecontroller.users[i]
                  //                         ['pass'],
                  //                     "photo": archivecontroller.users[i]
                  //                         ['photo'],
                  //                   });
                  //                 },
                  //                 icon: const Icon(
                  //                   Icons.update,
                  //                   color: Colors.black,
                  //                 )),
                  //           ]),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ),
              ),
            ],
          ),
        ),
      ]),
      //),
    );
  }
}
