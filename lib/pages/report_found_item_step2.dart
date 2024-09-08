import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lost_property/globals/regular_text.dart';
import '../blocs/report_found_item_bloc.dart';
import '../globals/colors.dart';
import '../globals/medium_text.dart';
import '../main.dart';
import '../models/post_model.dart';
import '../widgets/custom_loading.dart';

class ReportFoundItemStep2 extends StatefulWidget {
  final Function(int) jumpToPage;
  final ReportFoundItemBloc bloc;
  const ReportFoundItemStep2({
    super.key,
    required this.jumpToPage,
    required this.bloc,
  });

  @override
  State<ReportFoundItemStep2> createState() => _ReportFoundItemStep2State();
}

class _ReportFoundItemStep2State extends State<ReportFoundItemStep2> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MediumText(color: grey800, size: 20, text: "拾獲物處置方式"),
                  const SizedBox(height: 8),
                  RegularText(color: red300, size: 12, text: "*以下三種方式擇一填寫"),
                  const SizedBox(height: 16),
                  // 拾獲方式
                  Column(
                    children:
                        List.generate(widget.bloc.fixways.length, (index) {
                      return buildDropdown(
                        fixways: widget.bloc.fixways,
                        index: index,
                      );
                    }),
                  ),
                  MediumText(color: grey800, size: 20, text: "備註"),
                  const SizedBox(height: 16),
                  // 留言備註
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: grey50,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MediumText(color: grey800, size: 14, text: "留言或備註"),
                          const SizedBox(height: 4),
                          textInput(
                            value: widget.bloc.fixComment,
                            isComment: true,
                            onTextChanged: (v) {
                              setState(() {
                                widget.bloc.fixComment = v;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              // 上一步
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => widget.jumpToPage(0),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: white50,
                      border: Border.all(color: primary500),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MediumText(
                      color: primary500,
                      size: 16,
                      text: "上一步",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              //  下一步
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    // 構造新的 PostModel
                    PostModel newPost = widget.bloc.constructNewPost();
                    // 模擬延遲
                    await Future.delayed(const Duration(seconds: 1));
                    allPost.insert(0, newPost);
                    Beamer.of(context)
                        .beamToNamed("/found_items/report_send?status=success");

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    margin: const EdgeInsets.all(16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: primary500,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: isLoading
                        ? const CustomLoadong()
                        : MediumText(
                            color: white50,
                            size: 16,
                            text: "完成",
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropdown({required List fixways, required int index}) {
    Map map = fixways[index];
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: grey50,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    for (int i = 0; i < fixways.length; i++) {
                      if (i == index) {
                        fixways[i]["active"] = !fixways[i]["active"];
                      } else {
                        fixways[i]["active"] = false;
                      }
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: map["active"] ? grey700 : grey300),
                          color:
                              map["active"] ? grey700 : Colors.transparent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      MediumText(color: grey800, size: 14, text: map["title"]),
                      const Spacer(),
                      Icon(
                        map["active"]
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: map["active"] ? grey700 : grey300,
                      ),
                    ],
                  ),
                ),
              ),
              if (map["active"])
                for (var i = 0; i < map["body"].length; i++)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MediumText(
                            color: grey500,
                            size: 12,
                            text: "${map["body"][i]["title"]}*"),
                        const SizedBox(height: 4),
                        textInput(
                          value: map["body"][i]["value"],
                          isComment: false,
                          onTextChanged: (v) {
                            setState(() {
                              map["body"][i]["value"] = v;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget textInput({
    required String? value,
    required bool isComment,
    required ValueChanged<String> onTextChanged, // 新增這個回調
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: MediaQuery.of(context).size.width,
      height: 38,
      decoration: BoxDecoration(
        color: white50,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        style: TextStyle(
          color: grey800,
          fontFamily: "NotoSansMedium",
          fontSize: 14,
        ),
        cursorColor: primary500,
        cursorHeight: 14,
        onChanged: onTextChanged, // 這裡將 onChanged 傳入
        decoration: InputDecoration(
          hintText: isComment ? "無則免填" : "",
          hintStyle: TextStyle(
            color: grey300,
            fontFamily: "NotoSansMedium",
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.only(bottom: 8),
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
