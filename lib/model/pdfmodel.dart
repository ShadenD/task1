// ignore_for_file: non_constant_identifier_names

import 'package:welcom/model/order.dart';
import 'package:welcom/model/user.dart';

class Invoice {
  final Orderss order;
  final Users Supplier;
  final Users Customer;
  final InvoiceInfo info;

  const Invoice({
    required this.order,
    required this.Supplier,
    required this.Customer,
    required this.info,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;
  final List descriptionPdf;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
    required this.descriptionPdf,
  });
}
