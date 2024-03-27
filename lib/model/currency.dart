// ignore_for_file: non_constant_identifier_names

class Currency1 {
  final String currencyName;
  final String currencySymbol;
  final double rate;

  Currency1({
    required this.currencyName,
    required this.currencySymbol,
    required this.rate,
  });
  Map<String, dynamic> toMap() => {
        'currencyName': currencyName,
        'currencySymbol': currencySymbol,
        'rate': rate,
      };
}
