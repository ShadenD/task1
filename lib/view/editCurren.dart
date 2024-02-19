// ignore_for_file: must_be_immutable, file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/currencyController.dart';
import 'package:welcom/controller/sidebarcontroller.dart';
import 'package:welcom/view/sidebar.dart';

class EditCurr extends StatelessWidget {
  EditCurr({super.key});
  TextEditingController currname = TextEditingController();
  TextEditingController currsymbol = TextEditingController();
  TextEditingController currrate = TextEditingController();
  CurrencyController currencyController = Get.put(CurrencyController());
  SideBarController sideBarController = Get.put(SideBarController());

  @override
  Widget build(BuildContext context) {
    currname.text = Get.arguments!['curreny_name'].toString();
    currsymbol.text = Get.arguments!['currency_symbol'].toString();
    currrate.text = Get.arguments!['rate'].toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Currency Here"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            controller: currname,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Currency Name',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: currsymbol,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Currency Symbol',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: currrate,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Currency Rate',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            minWidth: double.infinity,
            height: 60,
            onPressed: () async {
              // sideBarController.index.value = 1;
              Map<String, String> currency = {
                'curreny_name': currname.text,
                'currency_symbol': currsymbol.text,
                'rate': currrate.text,
              };
              await currencyController.updateCurrency(
                  'currency', currency, Get.arguments['id']);
              print(sideBarController.index.value);
              currencyController.currency.clear();
              currencyController.readData2();
              Get.off(() => SideBarPage());

              //Get.to(() => sideBarController.pages[p]);
            },
            color: Colors.greenAccent,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: const Text(
              "Edit_Currency",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          )
        ]),
      ),
    );
  }
}
