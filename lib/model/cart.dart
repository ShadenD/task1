// ignore_for_file: camel_case_types

import 'package:welcom/model/itemModel.dart';

class cart {
  final List<itemModel> _items = [];
  double _totalPrice = 0.0;
  void add(itemModel item) {
    _items.add(item);
    _totalPrice += item.price;
  }

  void remove(itemModel item) {
    _totalPrice -= item.price;
    _items.remove(item);
  }

  int get count {
    return _items.length;
  }

  double get totalPrice {
    return _totalPrice;
  }

  List<itemModel> get basketItems {
    return _items;
  }
}
