import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/post_model.dart';

class ReportFoundItemBloc {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController lostTimeController = TextEditingController();
  final TextEditingController lostLocationController = TextEditingController();
  final TextEditingController itemFeatureController = TextEditingController();
  String? selectedDistrict;
  String? selectedItemType;
  String? fixComment;
  DateTime? selectedDate;

  // 設置日期
  void setSelectedDate(DateTime date) {
    selectedDate = date;
    lostTimeController.text = DateFormat('yyyy-MM-dd').format(date);
  }

  // 構造新的PostModel
  PostModel constructNewPost() {
    List<Map> _list = [];
    Map map = fixways.firstWhere((e) => e["active"] == true);
    _list.add({"title": "處置方式", "value": map["title"]});
    for (var i in map["body"]) {
      _list.add({"title": i["title"], "value": i["value"]});
    }
    if (fixComment?.isNotEmpty ?? false) {
      _list.add({"title": "留言或備註", "value": fixComment});
    }
    return PostModel(
      itemName: itemNameController.text,
      itemType: selectedItemType ?? '',
      lostDistrict: selectedDistrict ?? '',
      lostLocation: lostLocationController.text,
      lostTime: selectedDate,
      datePublished: DateTime.now(),
      itemFeature: itemFeatureController.text,
      postId: generateRandomId(),
      pic: generateImage(selectedItemType ?? "umbrella"),
      status: false,
      fixways: _list,
    );
  }

  // Dispose所有controller
  void dispose() {
    itemNameController.dispose();
    lostTimeController.dispose();
    lostLocationController.dispose();
    itemFeatureController.dispose();
  }

  List<Map> fixways = [
    {
      "title": "交由警察局",
      "active": false,
      "body": [
        {"title": "分局名稱", "value": ""},
        {"title": "收據編號", "value": ""},
      ]
    },
    {
      "title": "交由附近店家、管理單位",
      "active": false,
      "body": [
        {"title": "店家、管理單位", "value": ""},
        {"title": "店家、管理單位交代事項(如何領取...)", "value": ""},
      ]
    },
    {
      "title": "自行保管",
      "active": false,
      "body": [
        {"title": "聯繫方式", "value": ""},
      ]
    },
  ];
}
