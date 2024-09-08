import 'package:flutter/material.dart';

class RegularText extends StatelessWidget {
  final Color color;
  final double size;
  final int? maxLines;
  final String text;
  final TextAlign? textAlign;

  const RegularText({
    super.key,
    required this.color,
    this.maxLines,
    required this.size,
    required this.text,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontFamily: "NotoSansRegular",
      ),
    );
  }
}
