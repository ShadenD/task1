// ignore_for_file: file_names
import 'package:welcom/model/currency.dart';
import 'package:welcom/model/order.dart';

class OrderArgument {
  final int id;
  final Currency currency;
  final Orderss order;

  OrderArgument(
      {required this.currency, required this.id, required this.order});
}
