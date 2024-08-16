import 'package:flutter/material.dart';

class ThemeHelper {
  InputDecoration textInputDecoration(
      [String lableText = "", String hintText = ""]) {
    return InputDecoration(
      labelText: lableText,
      labelStyle: const TextStyle(color: Colors.lightGreen),
      hintText: hintText,
      fillColor: Colors.lightGreen.shade50,
      filled: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.lightGreen)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.lightGreen)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.lightGreen, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.lightGreen, width: 2.0)),
    );
  }

  InputDecoration textInputDecoReport(
      [String hintText = "", Widget? suffixIcon, Color? fillColor]) {
    return InputDecoration(
      hintText: hintText,
      fillColor: fillColor ?? Colors.lightGreen.shade50,
      filled: true,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.lightGreen)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.lightGreen)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.lightGreen, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.lightGreen, width: 2.0)),
    );
  }

  BoxDecoration inputBoxDecorationShaddow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.lightGreen.shade900.withOpacity(0.1),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
  }
}

getCustomButton(
    {String? text,
    Color? background,
    Color? textcolor,
    double? fontSize,
    Icon? icon,
    Function()? onPressed,
    double? padding}) {
  return Container(
    padding: const EdgeInsets.only(bottom: 10),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        )),
        minimumSize: WidgetStateProperty.all(const Size(50, 50)),
        backgroundColor: WidgetStateProperty.all(background),
        padding: WidgetStateProperty.all(EdgeInsets.only(
            bottom: 15, top: 15, left: padding!, right: padding)),
        textStyle: WidgetStateProperty.all(TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        )),
      ),
      child: Row(
        children: [
          icon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: icon,
                )
              : Container(),
          Text(
            text!,
            textAlign: TextAlign.center,
            style: TextStyle(color: textcolor),
          ),
        ],
      ),
    ),
  );
}
