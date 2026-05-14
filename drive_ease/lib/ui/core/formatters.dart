import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AppFormatters {
  // Currency Formatter
  static final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String formatCurrency(String? priceString) {
    if (priceString == null || priceString.isEmpty) return 'Rp 0';
    final price = double.tryParse(priceString) ?? 0;
    return currencyFormatter.format(price);
  }

  // License Plate Formatter
  static final licensePlateMask = MaskTextInputFormatter(
    mask: '@@ #### @@@', // allowing 2 prefix letters, 4 numbers, up to 3 suffix letters
    filter: {
      "@": RegExp(r'[A-Za-z]'),
      "#": RegExp(r'[0-9]')
    },
  );

  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(dateTime.toLocal());
  }
}