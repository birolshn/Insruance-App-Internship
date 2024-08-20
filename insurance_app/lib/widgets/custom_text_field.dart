import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {super.key, required this.text, required this.controller, required this.maxLength, required this.keyboardType, required this.validator, required this.onSaved, this.inputFormatters});

  final String text;
  final TextEditingController controller;
  final int maxLength;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  
 


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: text,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 112, 136, 113),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 181, 207, 183),
            width: 2.0,
          ),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      inputFormatters: inputFormatters,
    );
  }
}
