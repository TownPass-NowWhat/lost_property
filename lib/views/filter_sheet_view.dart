// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import '../globals/colors.dart';
import '../globals/medium_text.dart';
import '../globals/regular_text.dart';

class FilterSheetView extends StatefulWidget {
  final ValueNotifier taipeiDistrictsNotifier;
  final ValueNotifier itemTypesNotifier;
  const FilterSheetView({
    super.key,
    required this.itemTypesNotifier,
    required this.taipeiDistrictsNotifier,
  });

  @override
  State<FilterSheetView> createState() => _FilterSheetViewState();
}

class _FilterSheetViewState extends State<FilterSheetView> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.87, // 高度占滿螢幕的80%
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 19,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediumText(color: grey800, size: 20, text: "地區"),
                    const SizedBox(height: 12),
                    // 地區
                    ValueListenableBuilder(
                        valueListenable: widget.taipeiDistrictsNotifier,
                        builder: (context, value, child) {
                          List taipeiDistricts = value;
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 153 / 48,
                              mainAxisSpacing: 12, // 垂直間距
                              crossAxisSpacing: 12, // 水平間距
                            ),
                            itemCount: taipeiDistricts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  widget.taipeiDistrictsNotifier.value[index]
                                      ["select"] = !widget
                                          .taipeiDistrictsNotifier.value[index]
                                      ["select"];
                                  widget.taipeiDistrictsNotifier
                                      .notifyListeners();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: taipeiDistricts[index]["select"]
                                          ? primary300
                                          : grey50,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: RegularText(
                                    color: taipeiDistricts[index]["select"]
                                        ? white50
                                        : grey800,
                                    size: 14,
                                    text: taipeiDistricts[index]["title"],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                    const SizedBox(height: 12),
                    MediumText(color: grey800, size: 20, text: "物品分類"),
                    const SizedBox(height: 12),
                    // 地區
                    ValueListenableBuilder(
                        valueListenable: widget.itemTypesNotifier,
                        builder: (context, value, child) {
                          List itemFeatures = value;
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 153 / 48,
                              mainAxisSpacing: 12, // 垂直間距
                              crossAxisSpacing: 12, // 水平間距
                            ),
                            itemCount: itemFeatures.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  widget.itemTypesNotifier.value[index]
                                          ["select"] =
                                      !widget.itemTypesNotifier.value[index]
                                          ["select"];
                                  widget.itemTypesNotifier.notifyListeners();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: itemFeatures[index]["select"]
                                        ? primary300
                                        : grey50,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: RegularText(
                                    color: itemFeatures[index]["select"]
                                        ? white50
                                        : grey800,
                                    size: 14,
                                    text: itemFeatures[index]["title"],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // 確認按鍵
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    (widget.itemTypesNotifier.value as List).forEach((e) {
                      e["select"] = false;
                    });
                    widget.itemTypesNotifier.notifyListeners();
                    (widget.taipeiDistrictsNotifier.value as List).forEach((e) {
                      e["select"] = false;
                    });
                    widget.taipeiDistrictsNotifier.notifyListeners();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 72,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: primary500),
                    ),
                    child: MediumText(color: primary500, size: 12, text: "重設"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 38,
                      decoration: BoxDecoration(
                        color: primary500,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: MediumText(color: white50, size: 12, text: "確認篩選"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
