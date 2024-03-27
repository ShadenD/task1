// ignore_for_file: file_names, must_be_immutable, camel_case_types, avoid_print
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:welcom/controller/itemController.dart';
import 'package:welcom/model/itemModel.dart';

class addItems extends StatelessWidget {
  addItems({super.key});
  TextEditingController itemName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  itemController itemcontroller = Get.put(itemController());

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      //  controllerCurrName.text currency1.currencyName;
      itemName.text = Get.arguments['itemName'];
      itemcontroller.selectedImagePath.value = Get.arguments['image'];
      price.text = Get.arguments['price'].toString();
      quantity.text = "${Get.arguments['quantity']}";
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Get.arguments == null
            ? const Text(
                'New Item',
                style: TextStyle(
                  color: Colors.black,
                ),
              )
            : const Text(
                'Edit Item',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          height: 400,
          child: FadeInUp(
            duration: const Duration(milliseconds: 1200),
            child: Form(
                key: formstate,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 20,
                        ),
                        Obx(
                          () => SizedBox(
                              height: 100,
                              width: 100,
                              child:
                                  itemcontroller.selectedImagePath.value == ''
                                      ? const Text(
                                          "select image from camera/gallery")
                                      : ClipOval(
                                          child: Image.file(File(itemcontroller
                                              .selectedImagePath.value)),
                                        )),
                        ),
                        const SizedBox(
                          height: 30,
                          width: 30,
                        ),
                        Obx(() => Text(
                              itemcontroller.selectedImageSize.value == ''
                                  ? ''
                                  : itemcontroller.selectedImageSize.value,
                              style: const TextStyle(fontSize: 20),
                            )),
                        IconButton(
                            onPressed: () {
                              itemcontroller.pickImage(ImageSource.camera);
                            },
                            icon: const Icon(Icons.camera_alt_outlined)),
                        IconButton(
                            onPressed: () {
                              itemcontroller.pickImage(ImageSource.gallery);
                            },
                            icon: const Icon(Icons.photo_album_outlined)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: itemName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Item Name',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: price,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Item Price',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: quantity,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Item quantity',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
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
                          itemModel item = itemModel(
                         
                              itemName: itemName.text,
                              image: itemcontroller.selectedImagePath.value,
                              price: double.parse(price.text),
                              quantity: int.parse(quantity.text),
                              unitTag: '');
                          if (Get.arguments == null) {
                            await itemcontroller.insert('items', item);
                          } else {
                            // Check if Get.arguments is a Map and then access 'itemId' key
                            if (Get.arguments is Map &&
                                Get.arguments!.containsKey('itemId')) {
                              await itemcontroller.updateItem(
                                  'items', item, Get.arguments['itemId']);
                            } else {
                              print("Error");
                            }
                          }

                          Get.back();
                        },
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Get.arguments == null
                            ? const Text('ADD Item',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18))
                            : const Text('SAVE CHANGES',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18)),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
