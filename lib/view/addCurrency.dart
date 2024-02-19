// ignore_for_file: must_be_immutable, avoid_print, file_names, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:welcom/controller/currencyController.dart';
import 'package:welcom/view/sidebar.dart';

class AddCurr extends GetView<CurrencyController> {
  AddCurr({super.key});
  TextEditingController controllerCurrName = TextEditingController();
  TextEditingController controllerCurrSymbol = TextEditingController();
  TextEditingController controllerRate = TextEditingController();
  CurrencyController controllerCurr = Get.put(CurrencyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Currency Here"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextFormField(
            controller: controllerCurrName,
            // keyboardType: TextInputType.text,
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
            controller: controllerCurrSymbol,
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
            controller: controllerRate,
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
          SizedBox(
            child: MaterialButton(
              minWidth: double.infinity,
              height: 60,
              onPressed: () async {
                Map<String, String> currency = {
                  'curreny_name': controllerCurrName.text,
                  'currency_symbol': controllerCurrSymbol.text,
                  'rate': controllerRate.text,
                };
                await controller.insert('currency', currency);

                controllerCurr.currency.clear();
                controllerCurr.readData2();
                Get.off(() => SideBarPage());
              },
              color: Colors.greenAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: const Text(
                "Save",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
