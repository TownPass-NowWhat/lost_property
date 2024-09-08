import 'package:flutter/material.dart';
import 'package:lost_property/globals/colors.dart';

class CustomLoadong extends StatelessWidget {
  const CustomLoadong({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          backgroundColor: grey300,
          color: white50,
        ),
      ),
    );
  }

}
