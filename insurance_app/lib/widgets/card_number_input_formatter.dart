import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    
    String newText = newValue.text.replaceAll(' ', '');
    
    
    if (newText.length > 4) {
      StringBuffer newString = StringBuffer();
      for (int i = 0; i < newText.length; i++) {
        if (i % 4 == 0 && i != 0) {
          newString.write(' ');
        }
        newString.write(newText[i]);
      }
      return newValue.copyWith(
        text: newString.toString(),
        selection: TextSelection.collapsed(offset: newString.length),
      );
    }
    return newValue;
  }
}