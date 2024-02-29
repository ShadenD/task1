// ignore_for_file: non_constant_identifier_names

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import "package:pdf/widgets.dart" as pw;
import 'package:pdf/widgets.dart';
import 'package:welcom/api/pdf_api.dart';
import 'package:welcom/model/user.dart';
import 'package:welcom/model/userPdf.dart';

class UserInvoicePDF {
  static Future generate(UserPdf userinvoice) async {
    final pdf = pw.Document();
    ByteData bytes = await rootBundle.load('assets/images/logo.png');
    Uint8List logobytes = bytes.buffer.asUint8List();
    final headersTable = [
      'Number\t',
      'Order_Date\t'
          'Amount\t\t\t',
      'Equal_Amount\t\t\t',
      'Currency\t\t\t\t',
      'Status\t\t\t',
      'Type\t',
    ];
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
              Logo(logobytes),
              Header(userinvoice),
              pw.SizedBox(height: PdfPageFormat.cm),
              pw.Divider(),
              pw.SizedBox(height: PdfPageFormat.cm),
              Body(userinvoice, headersTable),
              pw.SizedBox(height: 30),
              pw.Divider(),
              // SizedBox(height: 30),
              signature(userinvoice),
              pw.SizedBox(height: PdfPageFormat.cm),
              buildFooter(userinvoice),
              pw.SizedBox(height: PdfPageFormat.cm),
            ]));
    return await PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static HeaderTable(List header) =>
      pw.TableRow(children: header.map((h) => pw.Text(h)).toList());

  static pw.Widget Logo(logobytes) => pw.Center(
      child: pw.Image(pw.MemoryImage(logobytes), height: 100.0, width: 100.0));

  static pw.Widget Header(UserPdf userinvoice) =>
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        buildSupplierAddress(userinvoice.supplier),
        pw.Container(
          height: 50,
          width: 50,
          child: BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: userinvoice.invoiceInfo.number,
          ),
        ),
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(
            'INVOICE',
            style: pw.TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          pw.Text(userinvoice.invoiceInfo.description),
          pw.Text('Invoice to '),
          pw.Text(userinvoice.customer.username,
              style: const pw.TextStyle(fontSize: 16.0)),
          pw.Text(userinvoice.customer.email,
              style: const pw.TextStyle(fontSize: 14.0)),
        ]),
      ]);
  static pw.Widget buildSupplierAddress(Users supplier) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(supplier.username,
              style: pw.TextStyle(fontWeight: FontWeight.bold)),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          pw.Text(supplier.email),
        ],
      );

  static pw.Widget Body(UserPdf userinvoice, List header) =>
      pw.Column(children: [
        pw.Table(
            border: const pw.TableBorder(bottom: pw.BorderSide(width: 1)),
            children: [
              pw.TableRow(children: header.map((h) => pw.Text(h)).toList()),
              for (var i = 0; i < userinvoice.orders1.length; i++)
                pw.TableRow(
                    // verticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      pw.Text('0${i + 1}'),
                      // pw.SizedBox(height: PdfPageFormat.cm),
                      pw.Text(userinvoice.orders1[i]['order_date']),
                      pw.Text('${userinvoice.orders1[i]['amount']}'),
                      pw.Text('${userinvoice.orders1[i]['equalAmount']}'),
                      pw.Text('${userinvoice.orders1[i]['currencyName']}'),
                      pw.Text(userinvoice.orders1[i]['status'] == 1
                          ? "Paid"
                          : "Not Paid"),
                      pw.Text('${userinvoice.orders1[i]['type']}'),
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
                      pw.Text('PDF Descriptions:\n\n',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      for (int i = 0;
                          i < userinvoice.invoiceInfo.descriptionPdf.length;
                          i++)
                        pw.Text(userinvoice.invoiceInfo.descriptionPdf[i],
                            textAlign: TextAlign.left)
                    ]),
                // pw.Positioned(
                //   bottom: 100.0,
                //   child: pw.Text(
                //       'Supplier Signature: ${userinvoice.supplier.username}'),
                // )
              ]),
        )
      ]);
  static Widget signature(UserPdf userinvoice) {
    return pw.Text('Supplier Signature: ${userinvoice.supplier.username}');
  }

  static pw.Widget buildFooter(UserPdf userinvoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Divider(),
          pw.SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'UserName', value: userinvoice.supplier.username),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Email', value: userinvoice.supplier.email),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = pw.TextStyle(fontWeight: FontWeight.bold);

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(title, style: style),
        pw.SizedBox(width: 2 * PdfPageFormat.mm),
        pw.Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? pw.TextStyle(fontWeight: FontWeight.bold);

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
