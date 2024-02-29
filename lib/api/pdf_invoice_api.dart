// ignore_for_file: non_constant_identifier_names, unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:welcom/api/pdf_api.dart';
import 'package:welcom/model/pdfmodel.dart';
import 'package:welcom/model/user.dart';
import 'package:welcom/utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();
    ByteData bytes = await rootBundle.load('assets/images/logo.png');
    Uint8List logobytes = bytes.buffer.asUint8List();
    pdf.addPage(MultiPage(
      build: (context) => [
        Logo(logobytes),
        buildHeader(invoice),
        SizedBox(height: PdfPageFormat.cm),
        buildTitle(invoice),
        pw.Divider(),
        Body(invoice),
        SizedBox(height: 5),
        signature(invoice),
        // pw.Divider(),
        // buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static pw.Widget Logo(logobytes) => pw.Center(
      child: pw.Image(pw.MemoryImage(logobytes), height: 100.0, width: 100.0));

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.Supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.Customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Users customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.username,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.email),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];
        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Users supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.username,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.email),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget Body(Invoice invoice) => pw.Column(children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Contact Customer:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Email: ${invoice.Customer.email}'),
            pw.Text('Phone No.: ${invoice.Customer.username}')
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Order Main Information:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Order Date: ${invoice.order.order_date}'),
            pw.Text('Order Type: ${invoice.order.type}'),
            pw.Text(
                'Order Status: ${invoice.order.status == 1 ? 'Paid' : 'Not Paid'}'),
          ]),
        ]),
        pw.Divider(),
        pw.Row(children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Order Details:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Order Amount: ${invoice.order.order_amount}'),
            pw.Text('Equal Order Amount: ${invoice.order.equal_order_amount}'),
            pw.Text(
                'Due To Date: ${DateFormat.yMMMd().format(DateTime(invoice.info.dueDate.year, invoice.info.dueDate.month, invoice.info.dueDate.day))}'),
          ]),
        ]),
        pw.Divider(),
        pw.Container(
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Description:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      for (int i = 0;
                          i < invoice.info.descriptionPdf.length;
                          i++)
                        pw.Text(invoice.info.descriptionPdf[i])
                    ]),
                // pw.Positioned(
                //   bottom: 100.0,
                //   child: pw.Text(
                //       'Supplier Signature: ${invoice.Supplier.username}'),
                // )
              ]),
        )
      ]);
  static Widget signature(Invoice invoice) {
    return pw.Text('Supplier Signature: ${invoice.Supplier.username}');
  }

  static Widget buildTotal(Invoice invoice) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'UserName', value: invoice.Supplier.username),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Email', value: invoice.Supplier.email),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
