import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_property/globals/medium_text.dart';
import 'package:lost_property/globals/regular_text.dart';
import 'package:lost_property/main.dart';
import 'package:lost_property/widgets/item_widget.dart';
import '../globals/colors.dart';
import '../models/post_model.dart';

class LookingItemDetailsPage extends StatefulWidget {
  final String postId;
  final List<PostModel> allPost;
  const LookingItemDetailsPage({
    super.key,
    required this.postId,
    required this.allPost,
  });

  @override
  State<LookingItemDetailsPage> createState() => Looking_ItemDetailsPageState();
}

class Looking_ItemDetailsPageState extends State<LookingItemDetailsPage> {
  late PostModel post =
      widget.allPost.firstWhere((e) => e.postId == widget.postId);
  late List<PostModel> relatePosts = widget.allPost
      .where((e) => e.itemType == post.itemType && e.postId != widget.postId)
      .toList();
  ScrollController scrollController = ScrollController(); // 控制滾動
  Timer? _timer; // 計時器
  bool isButtonVisible = true; // 控制按鈕的顯示與隱藏
  Duration duration = const Duration(milliseconds: 250); // 0.5 秒後顯示按鈕

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _timer?.cancel(); // 釋放計時器資源
    super.dispose();
  }

  void _onScroll() {
    // 每次滾動時取消之前的計時器
    _timer?.cancel();

    // 隱藏按鈕
    setState(() {
      isButtonVisible = false;
    });

    // 設置新的計時器，當滾動停止 0.5 秒後顯示按鈕
    _timer = Timer(duration, () {
      setState(() {
        isButtonVisible = true; // 顯示按鈕
      });
    });
  }

  late List detailList = [
    {
      "index": "lostTime",
      "title": "遺失日期",
      "value": DateFormat('yyyy-MM-dd').format(post.lostTime),
    },
    {
      "index": "lostDistrict",
      "title": "可能的遺失地區",
      "value": post.lostDistrict,
    },
    {
      "index": "lostLocation",
      "title": "可能的遺失地點",
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 第一塊
                    titleArea(),
                    // 第二塊
                    Container(
                      height: 146,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (Map i in detailList)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RegularText(
                                  color: grey700,
                                  size: 14,
                                  text: i["title"],
                                  maxLines: 2,
                                ),
                                const SizedBox(width: 20),
                                Flexible(
                                  // 使用 Flexible 或 Expanded 來確保文字可以換行
                                  child: RegularText(
                                    textAlign: TextAlign.end,
                                    color: grey700,
                                    size: 14,
                                    text: i["value"],
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    // 編輯按鈕
                    GestureDetector(
                      onTap: () => Beamer.of(context).beamToNamed(
                          "/looking_items/report?postId=${widget.postId}"),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: primary500,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: MediumText(
                            color: white50, size: 16, text: "編輯遺失物資料"),
                      ),
                    ),
                    // 相似物品
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: grey100,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: MediumText(
                                color: grey800, size: 16, text: "可能是您的物品"),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              relatePosts.length,
                              (index) {
                                return ItemWidget(post: relatePosts[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isButtonVisible) // 按鈕只在 `isButtonVisible` 為 true 時顯示
              GestureDetector(
                onTap: () {
                  post.status = !post.status;
                  int index =
                      allPost.indexWhere((e) => e.postId == widget.postId);
                  allPost[index] = post;
                  print("post status:${allPost[index].status}");
                  setState(() {});
                },
                child: Container(
                  width: 124,
                  margin: const EdgeInsets.only(bottom: 21),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: post.status ? primary500 : red300,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/report.png",
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 4),
                      MediumText(
                        color: grey0,
                        size: 16,
                        text: post.status ? "我已尋回" : "我未尋回",
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget titleArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
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
                      "${DateFormat('yyyy-MM-dd').format(post.datePublished)} 通報 | ",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                    fontFamily: "NotoSansRegular",
                  ),
                ),
                TextSpan(
                  text: post.status ? "已尋回" : "未尋回",
                  style: TextStyle(
                    color: post.status ? green500 : red300,
                    fontSize: 14,
                    fontFamily: "NotoSansRegular",
                  ),
                ),
                TextSpan(
                  text: " | ${relatePosts.length}項相似物品", // 後面的文字
                  style: TextStyle(
                    color: Colors.grey[800], // 正常文字的顏色
                    fontSize: 14, fontFamily: "NotoSansRegular",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: grey100,
          ),
        ],
      ),
    );
  }
}
