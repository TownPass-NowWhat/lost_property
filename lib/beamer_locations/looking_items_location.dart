// ignore_for_file: invalid_use_of_protected_member
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lost_property/globals/colors.dart';
import 'package:lost_property/main.dart';
import 'package:lost_property/pages/looking_items_page.dart';
import 'package:lost_property/pages/report_send_page.dart';
import '../models/post_model.dart';
import '../pages/looking_item_details_page.dart';
import '../pages/report_looking_item.dart';

class LookingItemsLocation extends BeamLocation {
  final List<PostModel> allPost;

  LookingItemsLocation({required this.allPost});
  List<String> get pathBlueprints => [
        '/looking_items',
        '/looking_items/details',
        '/looking_items/report',
        '/looking_items/report_send'
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    Uri uri = state.toRouteInformation().uri;
    String? tabParam = uri.queryParameters['tab'];
    int initialTab =
        tabParam != null ? int.parse(tabParam) : 0; // 如果有 tab 參數，解析並設置默認 Tab
    Widget page = LookingItemsPage(allPost: allPost, initialTab: initialTab);
    debugPrint('uri: $uri');
    if (uri.pathSegments.contains('details')) {
      updateTabTitle("遺失物詳情");
      String postId = uri.queryParameters['postId'] ?? "";
      page = LookingItemDetailsPage(postId: postId, allPost: allPost);
    } else if (uri.pathSegments.contains('report')) {
      updateTabTitle("遺失物協尋");
      String postId = uri.queryParameters['postId'] ?? "";
      page = ReportLookingItem(allPost: allPost, postId: postId);
    } else if (uri.pathSegments.contains('report_send')) {
      updateTabTitle("通報完成");

      String status = uri.queryParameters['status'] ?? "";
      page = ReportSendPage(
        status: status,
      );
    } else {
      updateTabTitle("尋找遺失物");
    }
    // if (uri.pathSegments.contains('inform')) {
    //   page =  InformLayout();
    // } else if (uri.pathSegments.contains('center')) {
    //   page = Container();
    // } else if (uri.pathSegments.contains('create')) {
    //   String step = uri.pathSegments[2];
    //   // final step = state.pathParameters['step'] ?? '0';
    //   switch (step) {
    //     case 'step1':
    //       page =  CreateStep1Layout();
    //       break;
    //     case 'step2':
    //       page = CreateStep2Layout();
    //       break;
    //   }
    // }
    return [
      BeamPage(
        key: ValueKey(uri),
        child: Scaffold(
          backgroundColor: grey0,
          body: page,
        ),
      )
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBlueprints;
}
