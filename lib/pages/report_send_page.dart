import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import '../globals/colors.dart';
import '../globals/medium_text.dart';

class ReportSendPage extends StatefulWidget {
  final String status;
  const ReportSendPage({
    super.key,
    required this.status,
  });

  @override
  State<ReportSendPage> createState() => _ReportSendPageState();
}

class _ReportSendPageState extends State<ReportSendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MediumText(color: grey800, size: 20, text: "通報成功"),
                const SizedBox(height: 32),
                Image.asset(
                  "assets/success.png",
                  height: 124,
                  width: 124,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          // 查看協尋物品狀態
          GestureDetector(
            onTap: () => Beamer.of(context).beamToNamed("/looking_items"),
            child: Container(
              width: double.infinity,
              height: 56,
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primary500,
                borderRadius: BorderRadius.circular(8),
              ),
              child: MediumText(color: white50, size: 16, text: "查看協尋物品狀態"),
            ),
          ),
        ],
      ),
    );
  }
}
