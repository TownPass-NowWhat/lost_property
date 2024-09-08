import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/post_model.dart';

class ReportLookingItemBloc {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController lostTimeController = TextEditingController();
  final TextEditingController lostLocationController = TextEditingController();
  final TextEditingController itemFeatureController = TextEditingController();
  String? selectedDistrict;
  String? selectedItemType;
  DateTime? selectedDate;

  // 設定初始值
  ReportLookingItemBloc({required PostModel? post}) {
    if (post != null) {
      itemNameController.text = post.itemName;
      lostTimeController.text = DateFormat('yyyy-MM-dd').format(post.lostTime);
      lostLocationController.text = post.lostLocation;
      itemFeatureController.text = post.itemFeature;
      selectedDistrict = post.lostDistrict;
      selectedItemType = post.itemType;
      selectedDate = post.lostTime;
    }
  }

  // 設置日期
  void setSelectedDate(DateTime date) {
    selectedDate = date;
    lostTimeController.text = DateFormat('yyyy-MM-dd').format(date);
  }

  // 構造新的PostModel
  PostModel constructNewPost(PostModel? post, {required String postId, required String pic}) {
    return PostModel(
      itemName: itemNameController.text,
      itemType: selectedItemType ?? '',
      lostDistrict: selectedDistrict ?? '',
      lostLocation: lostLocationController.text,
      lostTime: selectedDate ?? DateTime.now(),
      datePublished: DateTime.now(),
      itemFeature: itemFeatureController.text,
      postId: post?.postId ?? postId,
      pic: post?.pic ?? pic,
      status: post?.status ?? false,
      fixways:[],
    );
  }

  // Dispose所有controller
  void dispose() {
    itemNameController.dispose();
    lostTimeController.dispose();
    lostLocationController.dispose();
    itemFeatureController.dispose();
  }
}
