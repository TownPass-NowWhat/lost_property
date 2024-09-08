// ignore_for_file: invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:lost_property/globals/colors.dart';

import '../pages/home_page.dart';

class MainLocation extends BeamLocation {
  List<String> get pathBlueprints => [
        '/main',
      ];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {

    Widget page = const Center(child: HomePage());
    Uri uri = state.toRouteInformation().uri;
    debugPrint('uri: $uri');
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
