import 'package:beamer/beamer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_property/globals/colors.dart';
import 'package:lost_property/globals/medium_text.dart';
import 'package:lost_property/main.dart';
import 'package:lost_property/widgets/custom_loading.dart';
import '../blocs/report_looking_item_bloc.dart';
import '../globals/custom_messengers.dart';
import '../models/post_model.dart';

class ReportLookingItem extends StatefulWidget {
  final List<PostModel> allPost;
  final String postId;

  const ReportLookingItem({
    super.key,
    required this.allPost,
    required this.postId,
  });

  @override
  State<ReportLookingItem> createState() => _ReportLookingItemState();
}

class _ReportLookingItemState extends State<ReportLookingItem> {
  late final ReportLookingItemBloc bloc;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    final post = widget.postId == ""
        ? null
        : widget.allPost.firstWhere((e) => e.postId == widget.postId);

    bloc = ReportLookingItemBloc(post: post); // 初始化Bloc
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MediumText(color: grey800, size: 20, text: "填寫遺失物資料"),
                  const SizedBox(height: 16),
                  textInput("遺失物名稱", "白色雨傘", bloc.itemNameController),
                  datePickerInput(),
                  buildDropdown(
                    "可能的遺失地區",
                    taipeiDistricts,
                    bloc.selectedDistrict,
                    (value) {
                      setState(() {
                        bloc.selectedDistrict = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  buildDropdown(
                    "遺失物類別",
                    itemTypes,
                    bloc.selectedItemType,
                    (value) {
                      setState(() {
                        bloc.selectedItemType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  textInput(
                      "遺失地點", "捷運松江南京、公車307號", bloc.lostLocationController),
                  textInput(
                      "遺失物特徵(顏色、形狀...等)", "白色", bloc.itemFeatureController),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                isLoading = true;
              });

              // 構造新的 PostModel
              final newPost = bloc.constructNewPost(
                widget.postId.isNotEmpty
                    ? widget.allPost
                        .firstWhere((e) => e.postId == widget.postId)
                    : null,
                postId: generateRandomId(),
                pic: "https://dummyimage.com/300x200/000/fff",
              );

              // 模擬延遲
              await Future.delayed(const Duration(seconds: 1));

              // 跳轉並將新生成的 post 帶到新的頁面
              if (widget.postId.isNotEmpty) {
                int index =
                    widget.allPost.indexWhere((e) => e.postId == widget.postId);
                widget.allPost[index] = newPost;
              } else {
                widget.allPost.insert(0, newPost);
              }
              Beamer.of(context)
                  .beamToNamed("/looking_items/report_send?status=success");

              setState(() {
                isLoading = false;
              });
            },
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
              child: isLoading
                  ? const CustomLoadong()
                  : MediumText(
                      color: white50,
                      size: 16,
                      text: widget.postId.isNotEmpty ? "修改通報" : "送出通報",
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumText(
          color: grey800,
          size: 14,
          text: label,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.only(right: 6),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: grey50,
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String?>(
              isExpanded: true,
              value: selectedValue,
              hint: Text(
                "選擇 $label",
                style: TextStyle(
                  color: grey300,
                  fontFamily: "NotoSansMedium",
                  fontSize: 14,
                ),
              ),
              onChanged: onChanged,
              buttonStyleData: const ButtonStyleData(
                height: 38,
              ),
              iconStyleData: IconStyleData(
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 20,
                iconEnabledColor: primary500,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                decoration: BoxDecoration(
                  color: white50,
                  borderRadius: BorderRadius.circular(5),
                ),
                offset: const Offset(0, 0),
              ),
              items: items.map((e) {
                return DropdownMenuItem<String?>(
                  value: e,
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      e,
                      style: TextStyle(
                        color: grey800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget textInput(
      String label, String hintText, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumText(
          color: grey800,
          size: 14,
          text: label,
        ),
        const SizedBox(height: 4),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: MediaQuery.of(context).size.width,
          height: 38,
          decoration: BoxDecoration(
            color: grey50,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: controller,
            autofocus: true,
            style: TextStyle(
              color: grey800,
              fontFamily: "NotoSansMedium",
              fontSize: 14,
            ),
            cursorColor: primary500,
            cursorHeight: 14,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(bottom: 8),
              hintText: "Ex: $hintText",
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
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget datePickerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumText(color: grey800, size: 14, text: "遺失日期"),
        const SizedBox(height: 4),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          width: MediaQuery.of(context).size.width,
          height: 38,
          decoration: BoxDecoration(
            color: grey50,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await Messenger.selectDate(
                context,
                bloc.selectedDate,
              );
              if (picked != null) {
                setState(() {
                  bloc.setSelectedDate(picked);
                });
              }
            },
            child: Row(
              children: [
                Text(
                  bloc.selectedDate == null
                      ? "Ex: 2024-09-04"
                      : DateFormat('yyyy-MM-dd').format(bloc.selectedDate!),
                  style: TextStyle(
                    color: bloc.selectedDate == null ? grey300 : grey800,
                    fontFamily: "NotoSansMedium",
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  "assets/calendar.png",
                  height: 20,
                  width: 20,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
