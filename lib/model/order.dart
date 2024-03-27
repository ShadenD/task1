// ignore_for_file: non_constant_identifier_names

class Orderss {
  String order_date;
  int order_amount;
  double equal_order_amount;
  int curr_id;
  bool status;
  String type;
  int user_id;
  int item_id;

  Orderss({
    required this.order_date,
    required this.order_amount,
    required this.equal_order_amount,
    required this.curr_id,
    required this.status,
    required this.type,
    required this.user_id,
    required this.item_id,
  });
  Map<String, dynamic> toMap() => {
        'order_date': order_date,
        'order_amount': order_amount,
        'equal_order_amount': equal_order_amount,
        'curr_id': curr_id,
        'status': status,
        'type': type,
        'user_id': user_id,
        'item_id': item_id,
      };
}
