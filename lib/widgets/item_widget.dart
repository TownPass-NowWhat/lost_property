import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_property/models/post_model.dart';
import '../globals/colors.dart';
import '../globals/medium_text.dart';

class ItemWidget extends StatefulWidget {
  final PostModel post;
  const ItemWidget({
    super.key,
    required this.post,
  });

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: grey300,
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: AssetImage(widget.post.pic),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MediumText(
                  color: grey800,
                  size: 16,
                  text: widget.post.itemName,
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "${DateFormat('yyyy-MM-dd').format(widget.post.lostTime)} 拾獲 | ",
                        style: TextStyle(
                          color: grey800,
                          fontSize: 14,
                          fontFamily: "NotoSansRegular",
                        ),
                      ),
                      TextSpan(
                        text: widget.post.lostDistrict,
                        style: TextStyle(
                          color: primary300,
                          fontSize: 14,
                          fontFamily: "NotoSansRegular",
                        ),
                      ),
                      TextSpan(
                        text: " | ${widget.post.itemType}", // 後面的文字
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
    );
  }
}
