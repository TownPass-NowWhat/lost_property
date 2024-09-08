import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lost_property/globals/colors.dart';
import 'package:lost_property/globals/medium_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double width2 = MediaQuery.of(context).size.width / 375 * 2;
  late double height2 = MediaQuery.of(context).size.height / 812 * 2;
  List<Map> list = [
    {
      "index": 0,
      "title": "想找遺失物",
      "assets": "assets/binocular.png",
      "route": "/looking_items",
    },
    {
      "index": 1,
      "title": "撿到遺失物",
      "assets": "assets/give.png",
      "route": "/found_items/report",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width2 * 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 想找遺失物圖卡
          buttonCard(map: list[0]),
          SizedBox(height: height2 * 21),
          // 撿到遺失物圖卡
          buttonCard(map: list[1]),
        ],
      ),
    );
  }

  Widget buttonCard({required Map map}) {
    String title = map["title"];
    String assets = map["assets"];
    return GestureDetector(
      onTap: () {
        Beamer.of(context).beamToNamed(map["route"]);
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: width2 * 10,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: primary500,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              width: 64,
              height: 64,
              assets,
              fit: BoxFit.cover,
            ),
            MediumText(
              color: grey800,
              size: 16,
              text: title,
            ),
          ],
        ),
      ),
    );
  }
}
