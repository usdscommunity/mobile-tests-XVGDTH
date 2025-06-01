import 'package:flutter/material.dart';

class FormComponent extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool hide; // Corresponds to obscureText
  final TextInputType
  textInputType; // Renommé pour clarté, correspond à keyboardType
  final TextStyle? hintStyle;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final TextStyle? inputTextStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final InputDecoration? decoration; // Nouveau paramètre pour decoration

  const FormComponent({
    super.key,
    required this.controller,
    this.hintText,
    this.hide = false,
    this.textInputType = TextInputType.text,
    this.hintStyle,
    this.border,
    this.focusedBorder,
    this.inputTextStyle,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.decoration, // Paramètre decoration ajouté
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: hide,
      keyboardType: textInputType,
      style: inputTextStyle,
      validator: validator,
      decoration:
          decoration ??
          InputDecoration(
            hintText: hintText,
            hintStyle: hintStyle,
            border: border ?? const OutlineInputBorder(),
            focusedBorder: focusedBorder ?? const OutlineInputBorder(),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 10.0,
            ),
            fillColor: Colors.white,
            filled: true, // Valeur par défaut pour filled
          ),
    );
  }
}
