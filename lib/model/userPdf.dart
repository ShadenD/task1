// ignore_for_file: file_names, non_constant_identifier_names
import 'package:welcom/model/pdfmodel.dart';
import 'package:welcom/model/user.dart';

class UserPdf {
  final List orders1;
  final Users supplier;
  final Users customer;
  final InvoiceInfo invoiceInfo;

  UserPdf(
      {required this.orders1,
      required this.supplier,
      required this.customer,
      required this.invoiceInfo});
}
