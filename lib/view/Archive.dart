// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:welcom/controller/sidebarcontroller.dart';
// import 'package:welcom/view/sidebar.dart';

// class Arr extends GetView<SideBarController> {
//   Arr({super.key});
//   SideBarController sideBarController = Get.put(SideBarController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // ignore: unnecessary_string_interpolations
//         title: Obx(() => Text("${sideBarController.nameppbar()}")),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         actions: [
//           sideBarController.logout(),
//         ],
//       ),
//       drawer: SideBarPage(),
//       body: Row(children: [
//         Expanded(
//             flex: 8,
//             child: Obx(
//                 () => sideBarController.pages[sideBarController.index.value])),
//       ]),
//     );
//   }
// }
