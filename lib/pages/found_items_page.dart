import 'package:flutter/material.dart';
import '../globals/colors.dart';
import '../globals/medium_text.dart';

class FoundItemsPage extends StatefulWidget {
  const FoundItemsPage({super.key});

  @override
  State<FoundItemsPage> createState() => _FoundItemsPageState();
}

class _FoundItemsPageState extends State<FoundItemsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MediumText(color: grey800, size: 16, text: "撿到遺失物"),
    );
  }
}
