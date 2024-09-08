import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_property/blocs/looking_items_bloc.dart';
import 'package:lost_property/models/post_model.dart';
import '../globals/colors.dart';
import '../globals/medium_text.dart';

class LookingItemsPageLookingView extends StatefulWidget {
  final ScrollController scrollController;
  final List<PostModel> posts;
  final LookingItemsBloc bloc;
  const LookingItemsPageLookingView({
    super.key,
    required this.posts,
    required this.scrollController,
    required this.bloc,
  });

  @override
  State<LookingItemsPageLookingView> createState() =>
      _LookingItemsPageLookingViewState();
}

class _LookingItemsPageLookingViewState
    extends State<LookingItemsPageLookingView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 篩選區域
        Row(
          children: [
            Expanded(
              child: searchBar(),
            ),
            const SizedBox(width: 16),
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primary500,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset(
                width: 16,
                height: 16,
                "assets/search.png",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => widget.bloc.showFilterSheet(context: context),
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: white50,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: primary500),
                ),
                child: Image.asset(
                  width: 16,
                  height: 16,
                  "assets/filter.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 列表區域
        Expanded(
          child: widget.posts.isEmpty
              ? Center(
                  child:
                      MediumText(color: grey800, size: 14, text: "No Result."),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  controller: widget.scrollController,
                  itemCount: widget.posts.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Beamer.of(context).beamToNamed(
                          "/found_items/details?postId=${widget.posts[index].postId}"),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  height: 64,
                                  width: 64,
                                  decoration: BoxDecoration(
                                    color: grey300,
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image:
                                          AssetImage(widget.posts[index].pic),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MediumText(
                                        color: grey800,
                                        size: 16,
                                        text: widget.posts[index].itemName,
                                      ),
                                      const SizedBox(height: 8),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${DateFormat('yyyy-MM-dd').format(widget.posts[index].lostTime)} 拾獲 | ",
                                              style: TextStyle(
                                                color: grey800,
                                                fontSize: 14,
                                                fontFamily: "NotoSansRegular",
                                              ),
                                            ),
                                            TextSpan(
                                              text: widget
                                                  .posts[index].lostDistrict,
                                              style: TextStyle(
                                                color: primary300,
                                                fontSize: 14,
                                                fontFamily: "NotoSansRegular",
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  " | ${widget.posts[index].itemType}", // 後面的文字
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
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            height: 1,
                            width: MediaQuery.of(context).size.width,
                            color: grey100,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget searchBar() {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: grey50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: widget.bloc.textEditingController,
        onChanged: (value) => widget.bloc.filterLookingView(),
        style: TextStyle(color: grey500),
        cursorColor: primary500,
        cursorHeight: 14,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 10),
          hintText: "搜索你想搜尋的關鍵字",
          hintStyle: TextStyle(
            color: grey300,
            fontFamily: "NotoSansMedium",
            fontSize: 14,
          ),
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
