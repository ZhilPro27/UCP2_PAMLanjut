import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/services.dart';

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

  // Adaptive License Plate Formatter for Indonesian formats
  static final licensePlateFormatter = _IndonesianLicensePlateFormatter();


  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(dateTime.toLocal());
  }
}

class _IndonesianLicensePlateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 1. Remove all spaces and convert to uppercase
    String text = newValue.text.toUpperCase().replaceAll(' ', '');
    
    // 2. Separate into groups: 
    //    Group 1: Initial letters (1-2 chars)
    //    Group 2: Numbers (1-4 digits)
    //    Group 3: Suffix letters (1-3 chars)
    
    String group1 = '';
    String group2 = '';
    String group3 = '';
    
    int i = 0;
    // Extract Group 1 (Letters)
    while (i < text.length && RegExp(r'[A-Z]').hasMatch(text[i])) {
      group1 += text[i];
      i++;
      if (group1.length == 2) break; // Max 2 initial letters
    }
    
    // Extract Group 2 (Numbers)
    while (i < text.length && RegExp(r'[0-9]').hasMatch(text[i])) {
      group2 += text[i];
      i++;
      if (group2.length == 4) break; // Max 4 numbers
    }
    
    // Extract Group 3 (Suffix Letters)
    while (i < text.length && RegExp(r'[A-Z]').hasMatch(text[i])) {
      group3 += text[i];
      i++;
      if (group3.length == 3) break; // Max 3 suffix letters
    }
    
    // 3. Construct formatted string
    String formatted = group1;
    if (group2.isNotEmpty) {
      formatted += ' $group2';
    } else if (text.length > group1.length && RegExp(r'[0-9]').hasMatch(text[group1.length])) {
      // Handles case where a number is being typed
       formatted += ' ';
    }

    if (group3.isNotEmpty) {
      formatted += ' $group3';
    } else if (text.length > group1.length + group2.length && RegExp(r'[A-Z]').hasMatch(text[group1.length + group2.length])) {
      // Handles case where a letter is being typed after numbers
       formatted += ' ';
    }
    
    // Handle cursor position. A simple approach is just placing it at the end if we type.
    // However, for more robust UX, we calculate offsets. Here we just put cursor at end for simplicity
    // since plate numbers are short and usually typed sequentially.
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}