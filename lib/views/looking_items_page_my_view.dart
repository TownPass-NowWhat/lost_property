import 'package:beamer/beamer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_property/blocs/looking_items_bloc.dart';
import 'package:lost_property/models/post_model.dart';

import '../globals/colors.dart';
import '../globals/medium_text.dart';

class LookingItemsPageMyView extends StatefulWidget {
  final List<PostModel> posts;
  final ScrollController scrollController;
  final LookingItemsBloc bloc;
  const LookingItemsPageMyView({
    super.key,
    required this.posts,
    required this.scrollController,
    required this.bloc,
  });

  @override
  State<LookingItemsPageMyView> createState() => _LookingItemsPageMyViewState();
}

class _LookingItemsPageMyViewState extends State<LookingItemsPageMyView> {
  String? searchText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDropdown(context),
        const SizedBox(height: 15),
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
                      onTap: () => Beamer.of(context)
                          .beamToNamed("/looking_items/details?postId=${widget.posts[index].postId}"),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            "${DateFormat('yyyy-MM-dd').format(widget.posts[index].datePublished)} 通報 | ",
                                        style: TextStyle(
                                          color: grey800,
                                          fontSize: 14,
                                          fontFamily: "NotoSansRegular",
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget.posts[index].status
                                            ? "已尋回"
                                            : "未尋回",
                                        style: TextStyle(
                                          color: widget.posts[index].status
                                              ? green500
                                              : red300,
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

  Widget _buildDropdown(BuildContext context) {
    List<String> items = ["全部", "已尋回", "未尋回"];
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: white50,
        border: Border.all(color: primary500),
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String?>(
          value: searchText,
          hint: MediumText(
            color: primary500,
            size: 14,
            text: "遺失物狀態",
            maxLines: 3,
          ),
          isExpanded: true,
          onChanged: (value) {
            widget.bloc.filterMyView(select: value ?? "全部");
            setState(() {
              searchText = value;
            });
          },
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 6),
          ),
          iconStyleData: IconStyleData(
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 20,
            iconEnabledColor: primary500,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: white50,
            ),
            offset: const Offset(0, 0),
          ),
          items: items.map((e) {
            Color color = grey800;
            if (e == "已尋回") {
              color = green500;
            } else if (e == "未尋回") {
              color = red300;
            }
            return DropdownMenuItem<String?>(
              value: e,
              child: SizedBox(
                width: double.infinity,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontFamily: "NotoSansMedium"),
                    children: [
                      TextSpan(
                        text: e,
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                        ),
                      ),
                      // WidgetSpan(
                      //   child: SizedBox(width: Dimensions.width5 * 2),
                      // ),
                      // TextSpan(
                      //   text: count[e].toString(),
                      //   style: TextStyle(
                      //     color: cColor.primary,
                      //     fontSize: 10,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
