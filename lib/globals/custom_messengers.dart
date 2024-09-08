import 'package:flutter/material.dart';
import 'package:lost_property/globals/colors.dart';

class Messenger {
  //選日期
  static Future<DateTime?> selectDate(
    BuildContext context,
    DateTime? selectedDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
      locale: const Locale("zh", "TW"), // 設置日期選擇器為繁體中文
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primary500,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    return picked;
  }
}
