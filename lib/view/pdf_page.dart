// ignore_for_file: must_be_immutable

import 'package:date_time/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

class PdfOpen extends StatelessWidget {
  PdfOpen({super.key});
  String pdffile = Get.arguments['File'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${DateTime.now().date}'),
      ),
      body: PDFView(
        filePath: pdffile,
      ),
    );
  }
}
