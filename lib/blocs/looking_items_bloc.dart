// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';

import '../globals/colors.dart';
import '../models/post_model.dart';
import '../views/filter_sheet_view.dart';

class LookingItemsBloc {
  String query = '';
  late ValueNotifier<List<PostModel>> lookingBooksNotifier;
  late ValueNotifier<List<PostModel>> myBooksNotifier;
  List<PostModel> _originList = [];
  final textEditingController = TextEditingController();

  LookingItemsBloc({required List<PostModel> originList}) {
    _originList = originList;
    lookingBooksNotifier = ValueNotifier(List.from(_originList));
    myBooksNotifier = ValueNotifier(List.from(_originList.sublist(20, 45)));
    myBooksNotifier.value.insert(0, _originList[0]);
    textEditingController.text = query;
    textEditingController.addListener(() {
      if (textEditingController.text.trim() == '') {
        query = '';
      } else {
        query = textEditingController.text.trim();
      }
    });
  }

  filterMyView({required String select}) {
    List<PostModel> postList = _originList.sublist(20, 45);
    if (select == "全部") {
    } else if (select == "已尋回") {
      postList = postList.where((post) => post.status == true).toList();
    } else if (select == "未尋回") {
      postList = postList.where((post) => post.status == false).toList();
    }
    myBooksNotifier.value = postList;
    myBooksNotifier.notifyListeners();
  }

  filterLookingView() {
    // 搜尋
    _searchLookingBooks();
    // 篩選
    _filterLookingBooks();
    lookingBooksNotifier.notifyListeners();
  }

  _filterLookingBooks() {
    List<String> _district = taipeiDistrictsNotifier.value
        .where((i) => i["select"] == true)
        .map((i) => i["title"] as String)
        .toList();

    List<String> _itemTypes = itemTypesNotifier.value
        .where((i) => i["select"] == true)
        .map((i) => i["title"] as String)
        .toList();
    if (_district.isNotEmpty) {
      lookingBooksNotifier.value = lookingBooksNotifier.value
          .where((post) => _district.contains(post.lostDistrict))
          .toList();
    }
    if (_itemTypes.isNotEmpty) {
      lookingBooksNotifier.value = lookingBooksNotifier.value
          .where((post) => _itemTypes.contains(post.itemType))
          .toList();
    }
  }

  _searchLookingBooks() {
    List<PostModel> postList = _originList;
    if (query != '') {
      List<PostModel> book = postList.where((e) {
        if (e.itemName.contains(query) ||
            e.lostDistrict.contains(query) ||
            e.lostLocation.contains(query)) {
          return true;
        }
        return false;
      }).toList();
      lookingBooksNotifier.value = book;
    } else {
      lookingBooksNotifier.value = _originList;
    }
  }

  showFilterSheet({required BuildContext context}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 控制高度
      backgroundColor: white50, // 設置背景色
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return FilterSheetView(
          itemTypesNotifier: itemTypesNotifier,
          taipeiDistrictsNotifier: taipeiDistrictsNotifier,
        );
      },
    );
    filterLookingView();
  }

  ValueNotifier<List<Map<String, dynamic>>> taipeiDistrictsNotifier =
      ValueNotifier([
    {'title': '中正區', 'select': false},
    {'title': '大同區', 'select': false},
    {'title': '中山區', 'select': false},
    {'title': '松山區', 'select': false},
    {'title': '大安區', 'select': false},
    {'title': '萬華區', 'select': false},
    {'title': '信義區', 'select': false},
    {'title': '士林區', 'select': false},
    {'title': '北投區', 'select': false},
    {'title': '內湖區', 'select': false},
    {'title': '南港區', 'select': false},
    {'title': '文山區', 'select': false}
  ]);

  ValueNotifier<List<Map<String, dynamic>>> itemTypesNotifier = ValueNotifier([
    {'title': '新臺幣', 'select': false},
    {'title': '外幣', 'select': false},
    {'title': '有價證券', 'select': false},
    {'title': '票券', 'select': false},
    {'title': '信用卡/金融卡/簽帳卡', 'select': false},
    {'title': '悠遊卡/一卡通', 'select': false},
    {'title': '其他儲值卡/會員卡', 'select': false},
    {'title': '身分證', 'select': false},
    {'title': '健保卡', 'select': false},
    {'title': '駕照', 'select': false},
    {'title': '行照', 'select': false},
    {'title': '印章', 'select': false},
    {'title': '其他證件/執照/證書', 'select': false},
    {'title': '手機', 'select': false},
    {'title': '相機', 'select': false},
    {'title': '電腦/平板電腦', 'select': false},
    {'title': '耳機', 'select': false},
    {'title': '家電', 'select': false},
    {'title': '其他3C器材/零件/電子', 'select': false},
    {'title': '手錶', 'select': false},
    {'title': '眼鏡', 'select': false},
    {'title': '服飾鞋靴', 'select': false},
    {'title': '珠寶飾品', 'select': false},
    {'title': '皮夾/錢包', 'select': false},
    {'title': '行李箱/背包/隨身包', 'select': false},
    {'title': '其他衣著/配件/包款', 'select': false},
    {'title': '雨具', 'select': false},
    {'title': '輪椅/輔助器', 'select': false},
    {'title': '杯/瓶/壺類', 'select': false},
    {'title': '玩具', 'select': false},
    {'title': '圖書/文具', 'select': false},
    {'title': '文書及其他紙本', 'select': false},
    {'title': '統一發票', 'select': false},
    {'title': '其他日常用品', 'select': false},
    {'title': '食品', 'select': false},
    {'title': '其他類', 'select': false}
  ]);
}
