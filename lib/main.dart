import 'dart:math';
import 'dart:html' as html;
import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lost_property/beamer_locations/found_items_location.dart';
import 'package:lost_property/beamer_locations/looking_items_location.dart';
import 'package:lost_property/globals/colors.dart';
import 'package:url_strategy/url_strategy.dart';
import 'beamer_locations/main_location.dart';
import 'models/post_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyClg6cezQQifbgWl4zlh33yDh78dDZrrWo",
        authDomain: "lost-property-198cd.firebaseapp.com",
        projectId: "lost-property-198cd",
        storageBucket: "lost-property-198cd.appspot.com",
        messagingSenderId: "377198262369",
        appId: "1:377198262369:web:12459b907d5906f2061220",
        measurementId: "G-HH1NLJ41EF"),
  );
  initializeDateFormatting('zh_Hant_TW', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 排序 allPost 列表，根據 datePublished 由新到舊排序
    allPost.sort((a, b) => b.datePublished.compareTo(a.datePublished));
    // 生成假資料
    return MaterialApp.router(
      locale: const Locale('zh', 'TW'), // 設置應用程序的語言為繁體中文
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'TW'), // 繁體中文支持
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // 支持 Cupertino 的本地化
      ],
      title: '失物招領系統',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: mainColor, // 主要颜色
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: grey500,
        ),
        useMaterial3: true,
      ),
      routeInformationParser: BeamerParser(),
      routerDelegate: BeamerDelegate(
        initialPath: '/main',
        setBrowserTabTitle: false,
        transitionDelegate: const NoAnimationTransitionDelegate(),
        locationBuilder: BeamerLocationBuilder(
          beamLocations: [
            MainLocation(),
            LookingItemsLocation(allPost: allPost), // 修改的 LookingItemsLocation
            FoundItemsLocation(allPost: allPost),
          ],
        ),
        // 使用 state.extra 傳遞 allPost
      ),
    );
  }
}

void updateTabTitle(String newTitle) {
  html.document.title = newTitle;
}

List<PostModel> allPost = [
  PostModel(
    itemName: "紅色錢包",
    itemType: "皮夾/錢包",
    lostDistrict: "中正區",
    lostLocation: "台北車站",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "紅色, 皮革",
    postId: generateRandomId(),
    pic: generateImage("皮夾_錢包"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "中正一分局"},
      {"title": "收據編號", "value": "20240830-001"},
    ],
  ),
  PostModel(
    itemName: "藍色手機",
    itemType: "手機",
    lostDistrict: "信義區",
    lostLocation: "101購物中心",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "藍色, 金屬, 螢幕裂痕",
    postId: generateRandomId(),
    pic: generateImage("手機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0912-345-678"},
    ],
  ),
  PostModel(
    itemName: "銀色手錶",
    itemType: "手錶",
    lostDistrict: "大安區",
    lostLocation: "大安森林公園",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "銀色, 金屬, 數字錶",
    postId: generateRandomId(),
    pic: generateImage("手錶"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "公園管理站"},
      {"title": "收據編號", "value": "20240901-002"},
    ],
  ),
  PostModel(
    itemName: "黑色行李箱",
    itemType: "行李箱/背包/隨身包",
    lostDistrict: "松山區",
    lostLocation: "松山機場",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "黑色, 布料, 24吋",
    postId: generateRandomId(),
    pic: generateImage("行李箱_背包_隨身包"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "松山機場派出所"},
      {"title": "收據編號", "value": "20240831-003"},
    ],
  ),
  PostModel(
    itemName: "黃色筆記型電腦",
    itemType: "電腦/平板電腦",
    lostDistrict: "士林區",
    lostLocation: "士林夜市",
    datePublished: DateTime(2024, 9, 5),
    lostTime: DateTime(2024, 9, 3),
    itemFeature: "黃色, 金屬, 輕薄型",
    postId: generateRandomId(),
    pic: generateImage("電腦_平板電腦"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0987-654-321"},
    ],
  ),
  PostModel(
    itemName: "綠色耳機",
    itemType: "耳機",
    lostDistrict: "內湖區",
    lostLocation: "內湖科技園區",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "綠色, 塑膠, 無線",
    postId: generateRandomId(),
    pic: generateImage("耳機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "科技園區便利商店"},
      {"title": "收據編號", "value": "20240830-004"},
    ],
  ),
  PostModel(
    itemName: "紅色手機",
    itemType: "手機",
    lostDistrict: "中山區",
    lostLocation: "美麗華百貨",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "紅色, 金屬, 螢幕無損",
    postId: generateRandomId(),
    pic: generateImage("手機"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0910-222-333"},
    ],
  ),
  PostModel(
    itemName: "藍色錢包",
    itemType: "皮夾/錢包",
    lostDistrict: "大同區",
    lostLocation: "圓山捷運站",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "藍色, 皮革, 有磁扣",
    postId: generateRandomId(),
    pic: generateImage("皮夾_錢包"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "圓山派出所"},
      {"title": "收據編號", "value": "20240830-005"},
    ],
  ),
  PostModel(
    itemName: "白色耳機",
    itemType: "耳機",
    lostDistrict: "北投區",
    lostLocation: "北投溫泉區",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 2),
    itemFeature: "白色, 無線耳機",
    postId: generateRandomId(),
    pic: generateImage("耳機"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "北投旅遊中心"},
      {"title": "收據編號", "value": "20240902-006"},
    ],
  ),
  PostModel(
    itemName: "銀色相機",
    itemType: "相機",
    lostDistrict: "士林區",
    lostLocation: "士林夜市",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "銀色, 金屬, 單眼相機",
    postId: generateRandomId(),
    pic: generateImage("相機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0922-333-444"},
    ],
  ),
  PostModel(
    itemName: "灰色背包",
    itemType: "行李箱/背包/隨身包",
    lostDistrict: "萬華區",
    lostLocation: "龍山寺夜市",
    datePublished: DateTime(2024, 9, 5),
    lostTime: DateTime(2024, 9, 3),
    itemFeature: "灰色, 布料, 20吋",
    postId: generateRandomId(),
    pic: generateImage("行李箱_背包_隨身包"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "夜市小吃攤"},
      {"title": "收據編號", "value": "20240903-007"},
    ],
  ),
  PostModel(
    itemName: "金色戒指",
    itemType: "珠寶飾品",
    lostDistrict: "信義區",
    lostLocation: "101購物中心",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "金色, 金屬",
    postId: generateRandomId(),
    pic: generateImage("珠寶飾品"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0987-123-456"},
    ],
  ),
  PostModel(
    itemName: "黑色雨傘",
    itemType: "雨具",
    lostDistrict: "中山區",
    lostLocation: "中山捷運站",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "黑色, 塑膠",
    postId: generateRandomId(),
    pic: generateImage("雨具"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "中山分局"},
      {"title": "收據編號", "value": "20240830-101"},
    ],
  ),
  PostModel(
    itemName: "銀色手錶",
    itemType: "手錶",
    lostDistrict: "士林區",
    lostLocation: "士林夜市",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "銀色, 金屬",
    postId: generateRandomId(),
    pic: generateImage("手錶"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0987-654-321"},
    ],
  ),
  PostModel(
    itemName: "藍色耳機",
    itemType: "耳機",
    lostDistrict: "北投區",
    lostLocation: "北投捷運站",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "藍色, 無線",
    postId: generateRandomId(),
    pic: generateImage("耳機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "捷運站服務中心"},
      {"title": "收據編號", "value": "20240831-102"},
    ],
  ),
  PostModel(
    itemName: "紅色手機",
    itemType: "手機",
    lostDistrict: "大同區",
    lostLocation: "台北車站",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "紅色, 智慧型手機",
    postId: generateRandomId(),
    pic: generateImage("手機"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0912-345-678"},
    ],
  ),
  PostModel(
    itemName: "銀色鑰匙",
    itemType: "鑰匙",
    lostDistrict: "信義區",
    lostLocation: "世貿展覽館",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 2),
    itemFeature: "銀色, 金屬",
    postId: generateRandomId(),
    pic: generateImage("鑰匙"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "展覽館服務中心"},
      {"title": "收據編號", "value": "20240902-103"},
    ],
  ),
  PostModel(
    itemName: "黃色雨具",
    itemType: "雨具",
    lostDistrict: "南港區",
    lostLocation: "南港捷運站",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "黃色, 雨衣",
    postId: generateRandomId(),
    pic: generateImage("雨具"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "南港分局"},
      {"title": "收據編號", "value": "20240831-104"},
    ],
  ),
  PostModel(
    itemName: "黑色皮夾",
    itemType: "皮夾/錢包",
    lostDistrict: "大安區",
    lostLocation: "信義商圈",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "黑色, 皮革",
    postId: generateRandomId(),
    pic: generateImage("皮夾_錢包"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0912-222-333"},
    ],
  ),
  PostModel(
    itemName: "紅色雨鞋",
    itemType: "服飾鞋靴",
    lostDistrict: "松山區",
    lostLocation: "松山火車站",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "紅色, 橡膠",
    postId: generateRandomId(),
    pic: generateImage("服飾鞋靴"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "火車站便利商店"},
      {"title": "收據編號", "value": "20240901-105"},
    ],
  ),
  PostModel(
    itemName: "紫色耳機",
    itemType: "耳機",
    lostDistrict: "士林區",
    lostLocation: "士林夜市",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "紫色, 無線",
    postId: generateRandomId(),
    pic: generateImage("耳機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "士林分局"},
      {"title": "收據編號", "value": "20240831-106"},
    ],
  ),
  PostModel(
    itemName: "綠色水壺",
    itemType: "杯/瓶/壺類",
    lostDistrict: "中正區",
    lostLocation: "中正紀念堂",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "綠色, 金屬",
    postId: generateRandomId(),
    pic: generateImage("杯_瓶_壺類"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0922-333-444"},
    ],
  ),
  PostModel(
    itemName: "紅色行李箱",
    itemType: "行李箱/背包/隨身包",
    lostDistrict: "大安區",
    lostLocation: "台北101",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 2),
    itemFeature: "紅色, 塑膠",
    postId: generateRandomId(),
    pic: generateImage("行李箱_背包_隨身包"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "信義分局"},
      {"title": "收據編號", "value": "20240902-107"},
    ],
  ),
  PostModel(
    itemName: "藍色背包",
    itemType: "行李箱/背包/隨身包",
    lostDistrict: "內湖區",
    lostLocation: "內湖捷運站",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "藍色, 布料",
    postId: generateRandomId(),
    pic: generateImage("行李箱_背包_隨身包"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0955-444-555"},
    ],
  ),
  PostModel(
    itemName: "黑色相機",
    itemType: "相機",
    lostDistrict: "士林區",
    lostLocation: "故宮博物院",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "黑色, 金屬",
    postId: generateRandomId(),
    pic: generateImage("相機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "博物館管理處"},
      {"title": "收據編號", "value": "20240831-108"},
    ],
  ),
  PostModel(
    itemName: "白色手機",
    itemType: "手機",
    lostDistrict: "信義區",
    lostLocation: "信義商圈",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 29),
    itemFeature: "白色, 智慧型手機",
    postId: generateRandomId(),
    pic: generateImage("手機"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0933-555-666"},
    ],
  ),
  PostModel(
    itemName: "銀色健保卡",
    itemType: "健保卡",
    lostDistrict: "萬華區",
    lostLocation: "龍山寺",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "銀色, 塑膠",
    postId: generateRandomId(),
    pic: generateImage("健保卡"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "萬華分局"},
      {"title": "收據編號", "value": "20240901-109"},
    ],
  ),
  PostModel(
    itemName: "紅色外幣",
    itemType: "外幣",
    lostDistrict: "松山區",
    lostLocation: "台北小巨蛋",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "紅色, 美金鈔票",
    postId: generateRandomId(),
    pic: generateImage("外幣"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0933-666-777"},
    ],
  ),
  PostModel(
    itemName: "藍色眼鏡",
    itemType: "眼鏡",
    lostDistrict: "中正區",
    lostLocation: "總統府",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "藍色, 塑膠框架",
    postId: generateRandomId(),
    pic: generateImage("眼鏡"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0944-777-888"},
    ],
  ),
  PostModel(
    itemName: "灰色印章",
    itemType: "印章",
    lostDistrict: "信義區",
    lostLocation: "象山步道",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "灰色, 木製",
    postId: generateRandomId(),
    pic: generateImage("印章"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "象山步道登山口小賣部"},
      {"title": "收據編號", "value": "20240901-110"},
    ],
  ),
  PostModel(
    itemName: "紅色圖書",
    itemType: "圖書/文具",
    lostDistrict: "士林區",
    lostLocation: "台北市立圖書館",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "紅色, 精裝書",
    postId: generateRandomId(),
    pic: generateImage("圖書_文具"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0955-888-999"},
    ],
  ),
  PostModel(
    itemName: "黑色駕照",
    itemType: "駕照",
    lostDistrict: "大安區",
    lostLocation: "大安森林公園",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "黑色, 塑膠",
    postId: generateRandomId(),
    pic: generateImage("駕照"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "大安分局"},
      {"title": "收據編號", "value": "20240901-111"},
    ],
  ),
  PostModel(
    itemName: "金色手錶",
    itemType: "手錶",
    lostDistrict: "內湖區",
    lostLocation: "內湖科學園區",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "金色, 金屬",
    postId: generateRandomId(),
    pic: generateImage("手錶"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0966-111-222"},
    ],
  ),
  PostModel(
    itemName: "藍色皮夾",
    itemType: "皮夾_錢包",
    lostDistrict: "中山區",
    lostLocation: "中山捷運站",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 8, 29),
    itemFeature: "藍色, 皮革",
    postId: generateRandomId(),
    pic: generateImage("皮夾_錢包"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0955-333-444"},
    ],
  ),
  PostModel(
    itemName: "紅色雨具",
    itemType: "雨具",
    lostDistrict: "大同區",
    lostLocation: "寧夏夜市",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "紅色, 塑膠",
    postId: generateRandomId(),
    pic: generateImage("雨具"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "夜市攤位"},
      {"title": "收據編號", "value": "20240830-113"},
    ],
  ),
  PostModel(
    itemName: "銀色手電筒",
    itemType: "其他日常用品",
    lostDistrict: "信義區",
    lostLocation: "信義威秀影城",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "銀色, 金屬",
    postId: generateRandomId(),
    pic: generateImage("其他日常用品"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0977-444-555"},
    ],
  ),
  PostModel(
    itemName: "黃色駕照",
    itemType: "駕照",
    lostDistrict: "大安區",
    lostLocation: "忠孝東路",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 2),
    itemFeature: "黃色, 塑膠",
    postId: generateRandomId(),
    pic: generateImage("駕照"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "大安分局"},
      {"title": "收據編號", "value": "20240902-114"},
    ],
  ),
  PostModel(
    itemName: "紫色眼鏡",
    itemType: "眼鏡",
    lostDistrict: "士林區",
    lostLocation: "士林夜市",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "紫色, 塑膠",
    postId: generateRandomId(),
    pic: generateImage("眼鏡"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0938-999-888"},
    ],
  ),
  PostModel(
    itemName: "黑色耳機",
    itemType: "耳機",
    lostDistrict: "萬華區",
    lostLocation: "龍山寺",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 29),
    itemFeature: "黑色, 金屬",
    postId: generateRandomId(),
    pic: generateImage("耳機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "萬華分局"},
      {"title": "收據編號", "value": "20240829-115"},
    ],
  ),
  PostModel(
    itemName: "綠色行照",
    itemType: "行照",
    lostDistrict: "松山區",
    lostLocation: "松山機場捷運站",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "綠色, 塑膠",
    postId: generateRandomId(),
    pic: generateImage("行照"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0978-555-666"},
    ],
  ),
  PostModel(
    itemName: "藍色相機",
    itemType: "相機",
    lostDistrict: "中山區",
    lostLocation: "中山捷運站",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "藍色, 金屬",
    postId: generateRandomId(),
    pic: generateImage("相機"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0933-666-777"},
    ],
  ),
  PostModel(
    itemName: "黑色手機",
    itemType: "手機",
    lostDistrict: "信義區",
    lostLocation: "台北101",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "黑色, 智慧型手機",
    postId: generateRandomId(),
    pic: generateImage("手機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "101服務中心"},
      {"title": "收據編號", "value": "20240830-116"},
    ],
  ),
  PostModel(
    itemName: "白色玩具",
    itemType: "玩具",
    lostDistrict: "中正區",
    lostLocation: "台北車站",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 29),
    itemFeature: "白色, 塑膠",
    postId: generateRandomId(),
    pic: generateImage("玩具"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0955-777-888"},
    ],
  ),
  PostModel(
    itemName: "紅色悠遊卡",
    itemType: "悠遊卡/一卡通",
    lostDistrict: "松山區",
    lostLocation: "松山文創園區",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "紅色, 塑膠卡片",
    postId: generateRandomId(),
    pic: generateImage("悠遊卡_一卡通"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "松山分局"},
      {"title": "收據編號", "value": "20240901-001"},
    ],
  ),
  PostModel(
    itemName: "銀色信用卡",
    itemType: "信用卡/金融卡/簽帳卡",
    lostDistrict: "信義區",
    lostLocation: "台北101",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 2),
    itemFeature: "銀色, 信用卡",
    postId: generateRandomId(),
    pic: generateImage("信用卡_金融卡_簽帳卡"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0955-111-222"},
    ],
  ),
  PostModel(
    itemName: "綠色駕照",
    itemType: "駕照",
    lostDistrict: "萬華區",
    lostLocation: "西門町",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 2),
    itemFeature: "綠色, 駕照",
    postId: generateRandomId(),
    pic: generateImage("駕照"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "萬華分局"},
      {"title": "收據編號", "value": "20240902-002"},
    ],
  ),
  PostModel(
    itemName: "藍色行李箱",
    itemType: "行李箱/背包/隨身包",
    lostDistrict: "中正區",
    lostLocation: "台北車站",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "藍色, 塑膠材質",
    postId: generateRandomId(),
    pic: generateImage("行李箱_背包_隨身包"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "車站行李服務台"},
      {"title": "收據編號", "value": "20240901-003"},
    ],
  ),
  PostModel(
    itemName: "白色雨傘",
    itemType: "雨具",
    lostDistrict: "大安區",
    lostLocation: "台大校園",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 2),
    itemFeature: "白色, 雨傘",
    postId: generateRandomId(),
    pic: generateImage("雨具"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0922-555-777"},
    ],
  ),
  PostModel(
    itemName: "黑色新臺幣",
    itemType: "新臺幣",
    lostDistrict: "內湖區",
    lostLocation: "內湖科學園區",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "黑色, 錢包內現金",
    postId: generateRandomId(),
    pic: generateImage("新臺幣"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "內湖分局"},
      {"title": "收據編號", "value": "20240901-004"},
    ],
  ),
  PostModel(
    itemName: "紅色手錶",
    itemType: "手錶",
    lostDistrict: "士林區",
    lostLocation: "士林夜市",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "紅色, 金屬材質",
    postId: generateRandomId(),
    pic: generateImage("手錶"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0955-888-999"},
    ],
  ),
  PostModel(
    itemName: "藍色手機",
    itemType: "手機",
    lostDistrict: "北投區",
    lostLocation: "北投公園",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "藍色, 智慧型手機",
    postId: generateRandomId(),
    pic: generateImage("手機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "北投公園服務台"},
      {"title": "收據編號", "value": "20240830-005"},
    ],
  ),
  PostModel(
    itemName: "金色身分證",
    itemType: "身分證",
    lostDistrict: "大同區",
    lostLocation: "寧夏夜市",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "金色, 塑膠卡片",
    postId: generateRandomId(),
    pic: generateImage("身分證"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "大同分局"},
      {"title": "收據編號", "value": "20240901-006"},
    ],
  ),
  PostModel(
    itemName: "紫色耳機",
    itemType: "耳機",
    lostDistrict: "中山區",
    lostLocation: "美麗華",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "紫色, 金屬耳機",
    postId: generateRandomId(),
    pic: generateImage("耳機"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0933-999-222"},
    ],
  ),
  PostModel(
    itemName: "綠色行照",
    itemType: "行照",
    lostDistrict: "信義區",
    lostLocation: "象山步道",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "綠色, 塑膠卡片",
    postId: generateRandomId(),
    pic: generateImage("行照"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "信義分局"},
      {"title": "收據編號", "value": "20240901-007"},
    ],
  ),
  PostModel(
    itemName: "紅色護照",
    itemType: "其他證件/執照/證書",
    lostDistrict: "大安區",
    lostLocation: "大安森林公園",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "紅色, 護照",
    postId: generateRandomId(),
    pic: generateImage("其他證件_執照_證書"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "公園管理處"},
      {"title": "收據編號", "value": "20240901-008"},
    ],
  ),
  PostModel(
    itemName: "黃色家電遙控器",
    itemType: "家電",
    lostDistrict: "松山區",
    lostLocation: "松山機場",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "黃色, 遙控器",
    postId: generateRandomId(),
    pic: generateImage("家電"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0911-987-654"},
    ],
  ),
  PostModel(
    itemName: "綠色印章",
    itemType: "印章",
    lostDistrict: "萬華區",
    lostLocation: "龍山寺",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "綠色, 印章",
    postId: generateRandomId(),
    pic: generateImage("印章"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "萬華分局"},
      {"title": "收據編號", "value": "20240901-009"},
    ],
  ),
  PostModel(
    itemName: "金色項鍊",
    itemType: "珠寶飾品",
    lostDistrict: "士林區",
    lostLocation: "士林夜市",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "金色, 金屬材質",
    postId: generateRandomId(),
    pic: generateImage("珠寶飾品"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0933-555-222"},
    ],
  ),
  PostModel(
    itemName: "銀色健保卡",
    itemType: "健保卡",
    lostDistrict: "中正區",
    lostLocation: "總統府",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "銀色, 健保卡",
    postId: generateRandomId(),
    pic: generateImage("健保卡"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由附近店家"},
      {"title": "店家名稱", "value": "總統府服務台"},
      {"title": "收據編號", "value": "20240830-010"},
    ],
  ),
  PostModel(
    itemName: "藍色杯子",
    itemType: "杯/瓶/壺類",
    lostDistrict: "大安區",
    lostLocation: "信義商圈",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 9, 1),
    itemFeature: "藍色, 金屬材質",
    postId: generateRandomId(),
    pic: generateImage("杯_瓶_壺類"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0911-222-333"},
    ],
  ),
  PostModel(
    itemName: "黃色有價證券",
    itemType: "有價證券",
    lostDistrict: "中山區",
    lostLocation: "中山捷運站",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "黃色, 紙本證券",
    postId: generateRandomId(),
    pic: generateImage("有價證券"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "中山分局"},
      {"title": "收據編號", "value": "20240830-011"},
    ],
  ),
  PostModel(
    itemName: "綠色行動電源",
    itemType: "其他3C器材/零件/電子",
    lostDistrict: "內湖區",
    lostLocation: "內湖文德站",
    datePublished: DateTime(2024, 9, 4),
    lostTime: DateTime(2024, 9, 2),
    itemFeature: "綠色, 塑膠材質",
    postId: generateRandomId(),
    pic: generateImage("其他3C器材_零件_電子"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0922-666-888"},
    ],
  ),
  PostModel(
    itemName: "銀色手機",
    itemType: "手機",
    lostDistrict: "松山區",
    lostLocation: "松山文創園區",
    datePublished: DateTime(2024, 9, 1),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "銀色, 金屬材質",
    postId: generateRandomId(),
    pic: generateImage("手機"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0933-555-111"},
    ],
  ),
  PostModel(
    itemName: "紅色皮夾",
    itemType: "皮夾/錢包",
    lostDistrict: "信義區",
    lostLocation: "台北101",
    datePublished: DateTime(2024, 9, 2),
    lostTime: DateTime(2024, 8, 31),
    itemFeature: "紅色, 皮革材質",
    postId: generateRandomId(),
    pic: generateImage("皮夾_錢包"),
    status: false,
    fixways: [
      {"title": "處置方式", "value": "交由警察局"},
      {"title": "分局名稱", "value": "信義分局"},
      {"title": "收據編號", "value": "20240831-012"},
    ],
  ),
  PostModel(
    itemName: "黃色外幣",
    itemType: "外幣",
    lostDistrict: "內湖區",
    lostLocation: "內湖科學園區",
    datePublished: DateTime(2024, 9, 3),
    lostTime: DateTime(2024, 8, 30),
    itemFeature: "黃色, 美金現鈔",
    postId: generateRandomId(),
    pic: generateImage("外幣"),
    status: true,
    fixways: [
      {"title": "處置方式", "value": "自行保管"},
      {"title": "聯繫方式", "value": "0955-444-555"},
    ],
  ),
];

List<String> taipeiDistricts = [
  '中正區',
  '大同區',
  '中山區',
  '松山區',
  '大安區',
  '萬華區',
  '信義區',
  '士林區',
  '北投區',
  '內湖區',
  '南港區',
  '文山區'
];

List<String> itemFeatures = ['雨具', '手機', '錢包', '鑰匙'];
List<String> itemTypes = [
  '新臺幣',
  '外幣',
  '有價證券',
  '票券',
  '信用卡/金融卡/簽帳卡',
  '悠遊卡/一卡通',
  '其他儲值卡/會員卡',
  '身分證',
  '健保卡',
  '駕照',
  '行照',
  '印章',
  '其他證件/執照/證書',
  '手機',
  '相機',
  '電腦/平板電腦',
  '耳機',
  '家電',
  '其他3C器材/零件/電子',
  '手錶',
  '眼鏡',
  '服飾鞋靴',
  '珠寶飾品',
  '皮夾/錢包',
  '行李箱/背包/隨身包',
  '其他衣著/配件/包款',
  '雨具',
  '輪椅/輔助器',
  '杯/瓶/壺類',
  '玩具',
  '圖書/文具',
  '文書及其他紙本',
  '統一發票',
  '其他日常用品',
  '食品',
  '其他類'
];
List<String> itemNames = ['雨傘', '手機', '皮夾', '車鑰匙'];

String generateRandomId() {
  final random = Random();
  return List.generate(10, (_) => random.nextInt(10).toString()).join();
}

generateImage(String imageName) {
  List pngList = [
    "手錶",
    '行李箱_背包_隨身包',
    '其他類',
    '信用卡_金融卡_簽帳卡',
    '食品',
    '健保卡',
    '悠遊卡_一卡通',
  ];
  String fullPath = 'assets/$imageName.jpg';
  if (pngList.contains(imageName)) {
    fullPath = 'assets/$imageName.png';
  }
  // 嘗試讀取圖片
  rootBundle.load(fullPath);
  return fullPath; // 成功找到，返回路徑
}
