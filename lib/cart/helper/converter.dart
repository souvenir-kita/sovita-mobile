import 'package:intl/intl.dart';

String rp(double amount) {
  // Use the `NumberFormat` class from the `intl` package
  final numberFormat = NumberFormat.currency(
    locale: 'id_ID', // Indonesian locale
    symbol: 'Rp',    // Currency symbol
    decimalDigits: 0, // No decimal digits for Rupiah
  );
  return numberFormat.format(amount);
}