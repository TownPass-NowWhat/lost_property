import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_property/blocs/report_found_item_bloc.dart';
import 'package:lost_property/main.dart';
import '../globals/colors.dart';
import '../globals/custom_messengers.dart';
import '../globals/medium_text.dart';

class ReportFoundItemStep1 extends StatefulWidget {
  final Function(int) jumpToPage;
  final ReportFoundItemBloc bloc;
  const ReportFoundItemStep1({
    super.key,
    required this.jumpToPage,
    required this.bloc,
  });

  @override
  State<ReportFoundItemStep1> createState() => _ReportFoundItemStep1State();
}

class _ReportFoundItemStep1State extends State<ReportFoundItemStep1> {

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
                  MediumText(color: grey800, size: 20, text: "拾獲物資料填寫"),
                  const SizedBox(height: 16),
                  textInput("拾獲物名稱", "白色雨傘", widget.bloc.itemNameController),
                  datePickerInput(),
                  buildDropdown(
                    "拾獲地區",
                    taipeiDistricts,
                    widget.bloc.selectedDistrict,
                    (value) {
                      setState(() {
                        widget.bloc.selectedDistrict = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  textInput(
                      "拾獲地點", "捷運松江南京、公車307號", widget.bloc.lostLocationController),
                  buildDropdown(
                    "拾獲物品類別",
                    itemTypes,
                    widget.bloc.selectedItemType,
                    (value) {
                      setState(() {
                        widget.bloc.selectedItemType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  textInput(
                      "拾獲物品特徵(顏色、形狀...等)", "白色", widget.bloc.itemFeatureController),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => widget.jumpToPage(1),
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
              child: MediumText(
                color: white50,
                size: 16,
                text: "下一步",
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
        MediumText(color: grey800, size: 14, text: "拾獲日期"),
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
                widget.bloc.selectedDate,
              );
              if (picked != null) {
                setState(() {
                  widget.bloc.setSelectedDate(picked);
                });
              }
            },
            child: Row(
              children: [
                Text(
                  widget.bloc.selectedDate == null
                      ? "Ex: 2024-09-04"
                      : DateFormat('yyyy-MM-dd').format(widget.bloc.selectedDate!),
                  style: TextStyle(
                    color: widget.bloc.selectedDate == null ? grey300 : grey800,
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
