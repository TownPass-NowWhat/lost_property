import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_property/main.dart';

import '../globals/colors.dart';
import '../globals/medium_text.dart';
import '../globals/regular_text.dart';
import '../models/post_model.dart';
import '../widgets/google_map_widget.dart';

class FoundItemDetailsPage extends StatefulWidget {
  final String postId;
  final List<PostModel> allPost;
  const FoundItemDetailsPage({
    super.key,
    required this.allPost,
    required this.postId,
  });

  @override
  State<FoundItemDetailsPage> createState() => _FoundItemDetailsPageState();
}

class _FoundItemDetailsPageState extends State<FoundItemDetailsPage> {
  late PostModel post = allPost.firstWhere((e) => e.postId == widget.postId);
  late List detailList = [
    {
      "index": "lostTime",
      "title": "遺失日期",
      "value": DateFormat('yyyy-MM-dd').format(post.lostTime),
    },
    {
      "index": "lostDistrict",
      "title": "拾獲地區",
      "value": post.lostDistrict,
    },
    {
      "index": "lostLocation",
      "title": "拾獲地點",
      "value": post.lostLocation,
    },
    {
      "index": "itemType",
      "title": "遺失物類別",
      "value": post.itemType,
    },
    {
      "index": "itemFeature",
      "title": "遺失物特徵",
      "value": post.itemFeature,
    },
  ];
  @override
  void initState() {
    super.initState();
    updateTabTitle(post.itemName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 第一塊
              title(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: grey100,
              ),
              // 第二塊
              second(list: detailList),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: grey100,
              ),
              // 第三塊
              second(list: post.fixways),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: grey100,
              ),
              // 地圖
              const SizedBox(height: 6),
              GoogleMapWidget(post: post),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Row(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: grey300,
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage(post.pic),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MediumText(
                color: grey800,
                size: 16,
                text: post.itemName,
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "${DateFormat('yyyy-MM-dd').format(post.lostTime)} 拾獲 | ",
                      style: TextStyle(
                        color: grey800,
                        fontSize: 14,
                        fontFamily: "NotoSansRegular",
                      ),
                    ),
                    TextSpan(
                      text: post.lostDistrict,
                      style: TextStyle(
                        color: primary300,
                        fontSize: 14,
                        fontFamily: "NotoSansRegular",
                      ),
                    ),
                    TextSpan(
                      text: " | ${post.itemType}", // 後面的文字
                      style: TextStyle(
                        color: grey800, // 正常文字的顏色
                        fontSize: 14,
                        fontFamily: "NotoSansRegular",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget second({required List list}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < list.length; i++)
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MediumText(
                      color: grey700,
                      size: 14,
                      text: list[i]["title"],
                      maxLines: 2,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      // 使用 Flexible 或 Expanded 來確保文字可以換行
                      child: RegularText(
                        textAlign: TextAlign.end,
                        color: grey700,
                        size: 14,
                        text: list[i]["value"],
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                if (i != list.length - 1) const SizedBox(height: 6),
              ],
            ),
        ],
      ),
    );
  }
}
