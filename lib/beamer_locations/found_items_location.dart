// ignore_for_file: invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lost_property/pages/found_item_details_page.dart';
import 'package:lost_property/pages/found_items_page.dart';

import '../blocs/report_found_item_bloc.dart';
import '../main.dart';
import '../models/post_model.dart';
import '../pages/report_found_item_step1.dart';
import '../pages/report_found_item_step2.dart';
import '../pages/report_send_page.dart';

class FoundItemsLocation extends BeamLocation {
  final List<PostModel> allPost;

  FoundItemsLocation({required this.allPost});
  List<String> get pathBlueprints => [
        '/found_items',
        '/found_items/details',
        '/found_items/report',
        '/found_items/report_send',
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    Widget page = const Center(child: FoundItemsPage());
    Uri uri = state.toRouteInformation().uri;
    debugPrint('uri: $uri');
    if (uri.pathSegments.contains('report')) {
      late final ReportFoundItemBloc bloc = ReportFoundItemBloc(); // 初始化Bloc;
      final PageController _controller = PageController();
      jumpToPage(int i) {
        _controller.jumpToPage(i);
      }

      updateTabTitle("拾獲物品通報");
      page = PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ReportFoundItemStep1(jumpToPage: jumpToPage, bloc: bloc),
          ReportFoundItemStep2(jumpToPage: jumpToPage, bloc: bloc),
        ],
      );
    } else if (uri.pathSegments.contains('report_send')) {
      updateTabTitle("通報完成");
      String status = uri.queryParameters['status'] ?? "";
      page = ReportSendPage(
        status: status,
      );
    } else if (uri.pathSegments.contains('details')) {
      String postId = uri.queryParameters['postId'] ?? "";
      page = FoundItemDetailsPage(postId: postId, allPost: allPost);
    }
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
        child: page,
      )
    ];
  }

  @override
  List<Pattern> get pathPatterns => pathBlueprints;
}
