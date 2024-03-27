// ignore_for_file: camel_case_types, file_names

class itemModel {

  String itemName;
  String? image;
  double price;
  final int? quantity;
  final String? unitTag;

  itemModel({
   
    required this.itemName,
    this.image,
    required this.price,
    required this.quantity,
    required this.unitTag,
  });

  itemModel.fromMap(Map<dynamic, dynamic> res)
      :
        itemName = res['itemName'],
        image = res["image"],
        price = res["price"],
        quantity = res["quantity"],
        unitTag = res["unitTag"];

  Map<String, dynamic> toMap() => {
    
        'itemName': itemName,
        'image': image,
        'price': price,
        'quantity': quantity,
        'unitTag': unitTag,
      };
}
