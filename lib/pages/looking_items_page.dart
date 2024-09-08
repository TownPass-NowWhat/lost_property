import 'dart:async';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lost_property/blocs/looking_items_bloc.dart';
import 'package:lost_property/globals/colors.dart';
import 'package:lost_property/globals/medium_text.dart';
import 'package:lost_property/views/looking_items_page_looking_view.dart';
import 'package:lost_property/views/looking_items_page_my_view.dart';

import '../models/post_model.dart';

class LookingItemsPage extends StatefulWidget {
  final List<PostModel> allPost;
  final int initialTab; // 接受初始的 tab 值
  const LookingItemsPage({
    super.key,
    required this.allPost,
    this.initialTab = 0, // 默認為第一個 Tab
  });

  @override
  State<LookingItemsPage> createState() => _LookingItemsPageState();
}

class _LookingItemsPageState extends State<LookingItemsPage>
    with TickerProviderStateMixin {
  late final TabController tabController =
      TabController(length: 2, vsync: this, initialIndex: widget.initialTab);

  bool isButtonVisible = true; // 控制按鈕的顯示與隱藏
  ScrollController scrollController = ScrollController(); // 控制滾動
  Timer? _timer; // 計時器
  Duration duration = const Duration(milliseconds: 250); // 0.5 秒後顯示按鈕
  late final LookingItemsBloc bloc =
      LookingItemsBloc(originList: widget.allPost);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        // 當 Tab 切換時，將選中的 Tab 值存到 URL
        Beamer.of(context)
            .beamToNamed("/looking_items?tab=${tabController.index}");
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          dividerColor: Colors.transparent,
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
          indicatorWeight: 4,
          tabs: const [
            Tab(text: '尋找遺失物'), // 第一個 Tab
            Tab(text: '我的遺失物'), // 第二個 Tab
          ],
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          TabBarView(
            controller: tabController,
            children: [
              // 已尋回
              ValueListenableBuilder(
                  valueListenable: bloc.lookingBooksNotifier,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: LookingItemsPageLookingView(
                        posts: value,
                        scrollController: scrollController,
                        bloc: bloc,
                      ),
                    );
                  }),
              // 未尋回
              ValueListenableBuilder(
                  valueListenable: bloc.myBooksNotifier,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: LookingItemsPageMyView(
                        posts: value,
                        scrollController: scrollController,
                        bloc: bloc,
                      ),
                    );
                  }),
            ],
          ),
          if (isButtonVisible) // 按鈕只在 `isButtonVisible` 為 true 時顯示
            GestureDetector(
              onTap: () =>
                  Beamer.of(context).beamToNamed("/looking_items/report"),
              child: Container(
                width: 140,
                margin: const EdgeInsets.only(bottom: 21),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: primary500,
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
                    MediumText(color: grey0, size: 16, text: "填寫遺失物"),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
